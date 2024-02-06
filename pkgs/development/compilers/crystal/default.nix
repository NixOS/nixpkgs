{ stdenv
, callPackage
, fetchFromGitHub
, fetchurl
, fetchpatch
, lib
, substituteAll
  # Dependencies
, boehmgc
, coreutils
, git
, gmp
, hostname
, libatomic_ops
, libevent
, libiconv
, libxml2
, libyaml
, libffi
, llvmPackages_13
, llvmPackages_15
, makeWrapper
, openssl
, pcre2
, pcre
, pkg-config
, readline
, tzdata
, which
, zlib
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

  nativeCheckInputs = [ git gmp openssl readline libxml2 libyaml libffi ];

  binaryUrl = version: rel:
    if arch == archs.aarch64-linux then
      "https://dev.alpinelinux.org/archive/crystal/crystal-${version}-aarch64-alpine-linux-musl.tar.gz"
    else if arch == archs.x86_64-darwin && lib.versionOlder version "1.2.0" then
      "https://github.com/crystal-lang/crystal/releases/download/${version}/crystal-${version}-${toString rel}-darwin-x86_64.tar.gz"
    else
      "https://github.com/crystal-lang/crystal/releases/download/${version}/crystal-${version}-${toString rel}-${arch}.tar.gz";

  genericBinary = { version, sha256s, rel ? 1 }:
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
    { version
    , sha256
    , binary
    , llvmPackages
    , doCheck ? true
    , extraBuildInputs ? [ ]
    , buildFlags ? [ "all" "docs" "release=1"]
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
          (substituteAll {
            src = ./tzdata.patch;
            inherit tzdata;
          })
        ]
        ++ lib.optionals (lib.versionOlder version "1.2.0") [
        # add support for DWARF5 debuginfo, fixes builds on recent compilers
        # the PR is 8 commits from 2019, so just fetch the whole thing
        # and hope it doesn't change
        (fetchpatch {
          url = "https://github.com/crystal-lang/crystal/pull/11399.patch";
          sha256 = "sha256-CjNpkQQ2UREADmlyLUt7zbhjXf0rTjFhNbFYLwJKkc8=";
        })
      ];

      outputs = [ "out" "lib" "bin" ];

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

      '' + lib.optionalString (stdenv.isDarwin && lib.versionAtLeast version "1.3.0" && lib.versionOlder version "1.7.0") ''
        # See https://github.com/NixOS/nixpkgs/pull/195606#issuecomment-1356491277
        substituteInPlace spec/compiler/loader/unix_spec.cr \
          --replace 'it "parses file paths"' 'pending "parses file paths"'
      '' + lib.optionalString (stdenv.cc.isClang && (stdenv.cc.libcxx != null)) ''
        # Darwin links against libc++ not libstdc++. Newer versions of clang (12+) require
        # libc++abi to be linked explicitly (see https://github.com/NixOS/nixpkgs/issues/166205).
        substituteInPlace src/llvm/lib_llvm.cr \
          --replace '@[Link("stdc++")]' '@[Link("c++", "-l${stdenv.cc.libcxx.cxxabi.libName}")]'
      '';

      # Defaults are 4
      preBuild = ''
        export CRYSTAL_WORKERS=$NIX_BUILD_CORES
        export threads=$NIX_BUILD_CORES
        export CRYSTAL_CACHE_DIR=$TMP
        export MACOSX_DEPLOYMENT_TARGET=10.11
      '';


      strictDeps = true;
      nativeBuildInputs = [ binary makeWrapper which pkg-config llvmPackages.llvm ];
      buildInputs = [
        boehmgc
        (if lib.versionAtLeast version "1.8" then pcre2 else pcre)
        libevent
        libyaml
        zlib
        libxml2
        openssl
      ] ++ extraBuildInputs
      ++ lib.optionals stdenv.isDarwin [ libiconv ];

      makeFlags = [
        "CRYSTAL_CONFIG_VERSION=${version}"
        "progress=1"
      ];

      LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

      FLAGS = [
        "--single-module" # needed for deterministic builds
      ] ++ lib.optionals (lib.versionAtLeast version "1.3.0" && lib.versionOlder version "1.6.1") [
        # ffi is only used by the interpreter and its spec are broken on < 1.6.1
        "-Dwithout_ffi"
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
          --suffix PATH : ${lib.makeBinPath [ pkg-config llvmPackages.clang which ]} \
          --suffix CRYSTAL_PATH : lib:$lib/crystal \
          --suffix PKG_CONFIG_PATH : ${
            lib.makeSearchPathOutput "dev" "lib/pkgconfig" finalAttrs.buildInputs
          } \
          --suffix CRYSTAL_LIBRARY_PATH : ${
            lib.makeLibraryPath finalAttrs.buildInputs
          }
        install -dm755 $lib/crystal
        cp -r src/* $lib/crystal/

        install -dm755 $out/share/doc/crystal/api
        cp -r docs/* $out/share/doc/crystal/api/
        cp -r samples $out/share/doc/crystal/

        install -Dm644 etc/completion.bash $out/share/bash-completion/completions/crystal
        install -Dm644 etc/completion.zsh $out/share/zsh/site-functions/_crystal

        install -Dm644 man/crystal.1 $out/share/man/man1/crystal.1

        install -Dm644 -t $out/share/licenses/crystal LICENSE README.md

        mkdir -p $out
        ln -s $bin/bin $out/bin
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

      meta = with lib; {
        inherit (binary.meta) platforms;
        description = "A compiled language with Ruby like syntax and type inference";
        homepage = "https://crystal-lang.org/";
        license = licenses.asl20;
        maintainers = with maintainers; [ david50407 manveru peterhoeg donovanglover ];
      };
    });
in
rec {
  binaryCrystal_1_2 = genericBinary {
    version = "1.2.2";
    sha256s = {
      x86_64-linux = "sha256-sW5nhihW/6Dkq95i3vJNWs2D1CtQhujhxVbgQCAas6E=";
      aarch64-darwin = "sha256-4VB4yYGl1/YeYSsHOZq7fdeQ8IQMfloAPhEU0iKrvxs=";
      x86_64-darwin = "sha256-4VB4yYGl1/YeYSsHOZq7fdeQ8IQMfloAPhEU0iKrvxs=";
      aarch64-linux = "sha256-QgPKUDFyodqY1+b85AybSpbbr0RmfISdNpB08Wf34jo=";
    };
  };

  crystal_1_2 = generic {
    version = "1.2.2";
    sha256 = "sha256-nyOXhsutVBRdtJlJHe2dALl//BUXD1JeeQPgHU4SwiU=";
    binary = binaryCrystal_1_2;
    llvmPackages = llvmPackages_13;
    extraBuildInputs = [ libatomic_ops ];
  };

  crystal_1_7 = generic {
    version = "1.7.3";
    sha256 = "sha256-ULhLGHRIZbsKhaMvNhc+W74BwNgfEjHcMnVNApWY+EE=";
    binary = binaryCrystal_1_2;
    llvmPackages = llvmPackages_13;
  };

  crystal_1_8 = generic {
    version = "1.8.2";
    sha256 = "sha256-YAORdipzpC9CrFgZUFlFfjzlJQ6ZeA2ekVu8IfPOxR8=";
    binary = binaryCrystal_1_2;
    llvmPackages = llvmPackages_15;
  };

  crystal_1_9 = generic {
    version = "1.9.2";
    sha256 = "sha256-M1oUFs7/8ljszga3StzLOLM1aA4fSfVPQlsbuDHGd84=";
    binary = binaryCrystal_1_2;
    llvmPackages = llvmPackages_15;
  };

  crystal = crystal_1_9;
}
