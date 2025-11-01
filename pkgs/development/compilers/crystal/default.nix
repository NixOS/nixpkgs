{
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchurl,
  lib,
  replaceVars,
  # Dependencies
  boehmgc,
  coreutils,
  git,
  gmp,
  hostname,
  libevent,
  libiconv,
  libxml2,
  libyaml,
  libffi,
  llvmPackages_19,
  llvmPackages_20,
  llvmPackages_21,
  makeWrapper,
  openssl,
  pcre2,
  pkg-config,
  installShellFiles,
  readline,
  tzdata,
  which,
  zlib,
}:

# We need to keep around at least the latest version released with a stable
# NixOS
let
  archs = {
    x86_64-linux = "linux-x86_64";
    i686-linux = "linux-i686";
    x86_64-darwin = "darwin-universal";
    aarch64-darwin = "darwin-universal";
    aarch64-linux = "linux-aarch64";
  };

  arch = archs.${stdenv.system} or (throw "system ${stdenv.system} not supported");

  nativeCheckInputs = [
    git
    gmp
    openssl
    readline
    libxml2
    libyaml
    libffi
  ];

  binaryUrl =
    version: rel:
    if arch == archs.aarch64-linux then
      "https://dev.alpinelinux.org/archive/crystal/crystal-${version}-aarch64-alpine-linux-musl.tar.gz"
    else
      "https://github.com/crystal-lang/crystal/releases/download/${version}/crystal-${version}-${toString rel}-${arch}.tar.gz";

  genericBinary =
    {
      version,
      sha256s,
      rel ? 1,
    }:
    stdenv.mkDerivation rec {
      pname = "crystal-binary";
      inherit version;

      src = fetchurl {
        url = binaryUrl version rel;
        sha256 = sha256s.${stdenv.system};
      };

      buildCommand = ''
        mkdir -p $out
        tar --strip-components=1 -C $out -xf ${src}
        patchShebangs $out/bin/crystal
      '';

      meta.platforms = lib.attrNames sha256s;
    };

  generic =
    {
      version,
      sha256,
      binary,
      llvmPackages,
      doCheck ? true,
      extraBuildInputs ? [ ],
      buildFlags ? [
        "all"
        "docs"
        "release=1"
      ],
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "crystal";
      inherit buildFlags doCheck version;

      src = fetchFromGitHub {
        owner = "crystal-lang";
        repo = "crystal";
        rev = version;
        inherit sha256;
      };

      patches = [
        (replaceVars ./tzdata.patch {
          inherit tzdata;
        })
      ];

      outputs = [
        "out"
        "lib"
        "bin"
      ];

      postPatch = ''
        export TMP=$(mktemp -d)
        export HOME=$TMP
        export TMPDIR=$TMP
        mkdir -p $HOME/test

        # Add dependency of crystal to docs to avoid issue on flag changes between releases
        # https://github.com/crystal-lang/crystal/pull/8792#issuecomment-614004782
        substituteInPlace Makefile \
          --replace 'docs: ## Generate standard library documentation' 'docs: crystal ## Generate standard library documentation'

        mkdir -p $TMP/crystal

        substituteInPlace spec/std/file_spec.cr \
          --replace '/bin/ls' '${coreutils}/bin/ls' \
          --replace '/usr/share' "$TMP/crystal" \
          --replace '/usr' "$TMP" \
          --replace '/tmp' "$TMP"

        substituteInPlace spec/std/process_spec.cr \
          --replace '/bin/cat' '${coreutils}/bin/cat' \
          --replace '/bin/ls' '${coreutils}/bin/ls' \
          --replace '/usr/bin/env' '${coreutils}/bin/env' \
          --replace '"env"' '"${coreutils}/bin/env"' \
          --replace '/usr' "$TMP" \
          --replace '/tmp' "$TMP"

        substituteInPlace spec/std/system_spec.cr \
          --replace '`hostname`' '`${hostname}/bin/hostname`'

        # See https://github.com/crystal-lang/crystal/issues/8629
        substituteInPlace spec/std/socket/udp_socket_spec.cr \
          --replace 'it "joins and transmits to multicast groups"' 'pending "joins and transmits to multicast groups"'

      ''
      + lib.optionalString (stdenv.cc.isClang && (stdenv.cc.libcxx != null)) ''
        # Darwin links against libc++ not libstdc++. Newer versions of clang (12+) require
        # libc++abi to be linked explicitly (see https://github.com/NixOS/nixpkgs/issues/166205).
        substituteInPlace src/llvm/lib_llvm.cr \
          --replace '@[Link("stdc++")]' '@[Link("c++")]'
      '';

      # Defaults are 4
      preBuild = ''
        export CRYSTAL_WORKERS=$NIX_BUILD_CORES
        export threads=$NIX_BUILD_CORES
        export CRYSTAL_CACHE_DIR=$TMP
        export MACOSX_DEPLOYMENT_TARGET=10.11
        export SOURCE_DATE_EPOCH="$(<src/SOURCE_DATE_EPOCH)"
      '';

      strictDeps = true;
      nativeBuildInputs = [
        binary
        makeWrapper
        which
        pkg-config
        llvmPackages.llvm
        installShellFiles
      ];
      buildInputs = [
        boehmgc
        pcre2
        libevent
        libyaml
        zlib
        libxml2
        openssl
      ]
      ++ extraBuildInputs
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

      makeFlags = [
        "CRYSTAL_CONFIG_VERSION=${version}"
        "progress=1"
      ];

      LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

      FLAGS = [
        "--single-module" # needed for deterministic builds
      ];

      # This makes sure we don't keep depending on the previous version of
      # crystal used to build this one.
      CRYSTAL_LIBRARY_PATH = "${placeholder "lib"}/crystal";

      # We *have* to add `which` to the PATH or crystal is unable to build
      # stuff later if which is not available.
      installPhase = ''
        runHook preInstall

        install -Dm755 .build/crystal $bin/bin/crystal
        wrapProgram $bin/bin/crystal \
          --suffix PATH : ${
            lib.makeBinPath [
              pkg-config
              llvmPackages.clang
              which
            ]
          } \
          --suffix CRYSTAL_PATH : lib:$lib/crystal \
          --suffix PKG_CONFIG_PATH : ${
            lib.makeSearchPathOutput "dev" "lib/pkgconfig" finalAttrs.buildInputs
          } \
          --suffix CRYSTAL_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}
        install -dm755 $lib/crystal
        cp -r src/* $lib/crystal/

        install -dm755 $out/share/doc/crystal/api
        cp -r docs/* $out/share/doc/crystal/api/
        cp -r samples $out/share/doc/crystal/

        installShellCompletion --cmd ${finalAttrs.meta.mainProgram} etc/completion.*

        installManPage man/crystal.1

        install -Dm644 -t $out/share/licenses/crystal LICENSE README.md

        mkdir -p $out
        ln -s $bin/bin $out/bin
        ln -s $bin/share/bash-completion $out/share/bash-completion
        ln -s $bin/share/zsh $out/share/zsh
        ln -s $bin/share/fish $out/share/fish
        ln -s $lib $out/lib

        runHook postInstall
      '';

      enableParallelBuilding = true;

      dontStrip = true;

      checkTarget = "compiler_spec";

      preCheck = ''
        export LIBRARY_PATH=${lib.makeLibraryPath nativeCheckInputs}:$LIBRARY_PATH
        export PATH=${lib.makeBinPath nativeCheckInputs}:$PATH
      '';

      passthru.buildBinary = binary;
      passthru.buildCrystalPackage = callPackage ./build-package.nix {
        crystal = finalAttrs.finalPackage;
      };
      passthru.llvmPackages = llvmPackages;

      meta = with lib; {
        inherit (binary.meta) platforms;
        description = "Compiled language with Ruby like syntax and type inference";
        mainProgram = "crystal";
        homepage = "https://crystal-lang.org/";
        license = licenses.asl20;
        maintainers = with maintainers; [
          david50407
          manveru
          peterhoeg
          donovanglover
        ];
      };
    });
in
rec {
  binaryCrystal_1_10 = genericBinary {
    version = "1.10.1";
    sha256s = {
      x86_64-linux = "sha256-F0LjdV02U9G6B8ApHxClF/o5KvhxMNukSX7Z2CwSNIs=";
      aarch64-darwin = "sha256-5kkObQl0VIO6zqQ8TYl0JzYyUmwfmPE9targpfwseSQ=";
      x86_64-darwin = "sha256-5kkObQl0VIO6zqQ8TYl0JzYyUmwfmPE9targpfwseSQ=";
      aarch64-linux = "sha256-AzFz+nrU/HJmCL1hbCKXf5ej/uypqV1GJPVLQ4J3778=";
    };
  };

  crystal_1_14 = generic {
    version = "1.14.1";
    sha256 = "sha256-cQWK92BfksOW8GmoXn4BmPGJ7CLyLAeKccOffQMh5UU=";
    binary = binaryCrystal_1_10;
    llvmPackages = llvmPackages_19;
    doCheck = false; # Some compiler spec problems on x86-64_linux with the .0 release
  };

  crystal_1_15 = generic {
    version = "1.15.1";
    sha256 = "sha256-L/Q8yZdDq/wn4kJ+zpLfi4pxznAtgjxTCbLnEiCC2K0=";
    binary = binaryCrystal_1_10;
    llvmPackages = llvmPackages_19;
    doCheck = false;
  };

  crystal_1_16 = generic {
    version = "1.16.3";
    sha256 = "sha256-U9H1tHUMyDNicZnXzEccDki5bGXdV0B2Wu2PyCksPVI=";
    binary = binaryCrystal_1_10;
    llvmPackages = llvmPackages_20;
    doCheck = false;
  };

  crystal_1_17 = generic {
    version = "1.17.1";
    sha256 = "sha256-+wHhozPhpIsfQy1Lw+V48zvuWCfXzT4IC9KA1AU/DLw=";
    binary = binaryCrystal_1_10;
    llvmPackages = llvmPackages_21;
    doCheck = false;
  };

  crystal_1_18 = generic {
    version = "1.18.2";
    sha256 = "sha256-bwKs9bwD1WfS95DSxVY5AjT5Q61jOsfAH897tmiurng=";
    binary = binaryCrystal_1_10;
    llvmPackages = llvmPackages_21;
    doCheck = false;
  };

  crystal = crystal_1_18;
}
