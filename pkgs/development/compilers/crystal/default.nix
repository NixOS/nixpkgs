{ stdenv
, callPackage
, fetchFromGitHub
, fetchurl
, fetchpatch
, lib
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
, llvmPackages
, makeWrapper
, openssl
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
  isAarch64Darwin = stdenv.system == "aarch64-darwin";

  checkInputs = [ git gmp openssl readline libxml2 libyaml libffi ];

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

      meta.broken = (lib.versionOlder version "1.2.0" && isAarch64Darwin) || (lib.versionAtLeast version "1.3.0" && stdenv.system == "i686-linux") || (lib.versionAtLeast version "1.5.0" && stdenv.system == "aarch64-linux");
    };

  commonBuildInputs = extraBuildInputs: [
    boehmgc
    pcre
    libevent
    libyaml
    zlib
    libxml2
    openssl
  ] ++ extraBuildInputs
  ++ lib.optionals stdenv.isDarwin [ libiconv ];

  generic = (
    { version
    , sha256
    , binary
    , doCheck ? true
    , extraBuildInputs ? [ ]
    , buildFlags ? [ "all" "docs" ]
    }:
    lib.fix (compiler: stdenv.mkDerivation {
      pname = "crystal";
      inherit buildFlags doCheck version;

      src = fetchFromGitHub {
        owner = "crystal-lang";
        repo = "crystal";
        rev = version;
        inherit sha256;
      };

      patches = [ ]
        ++ lib.optionals (lib.versionOlder version "1.2.0") [
        # add support for DWARF5 debuginfo, fixes builds on recent compilers
        # the PR is 8 commits from 2019, so just fetch the whole thing
        # and hope it doesn't change
        (fetchpatch {
          url = "https://github.com/crystal-lang/crystal/pull/11399.patch";
          sha256 = "sha256-CjNpkQQ2UREADmlyLUt7zbhjXf0rTjFhNbFYLwJKkc8=";
        })
      ] ++ lib.optionals (lib.versionAtLeast version "1.3.0" && lib.versionOlder version "1.6.1") [
        # fixes an issue that prevented tests from passing when ran with
        # the --release flag
        # the PR has been merged since version 1.6.1
        (fetchpatch {
          url = "https://github.com/crystal-lang/crystal/pull/12601.patch";
          sha256 = "sha256-3NiUC4EyP/jSn62sv38eieKcVw9zUfRB78aAvnxV57E=";
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

        substituteInPlace src/crystal/system/unix/time.cr \
          --replace /usr/share/zoneinfo ${tzdata}/share/zoneinfo

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
      '';

      # Defaults are 4
      preBuild = ''
        export CRYSTAL_WORKERS=$NIX_BUILD_CORES
        export threads=$NIX_BUILD_CORES
        export CRYSTAL_CACHE_DIR=$TMP
      '';


      strictDeps = true;
      nativeBuildInputs = [ binary makeWrapper which pkg-config llvmPackages.llvm ];
      buildInputs = commonBuildInputs extraBuildInputs;

      makeFlags = [
        "CRYSTAL_CONFIG_VERSION=${version}"
        "release=1"
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
          --suffix PATH : ${lib.makeBinPath [ pkg-config llvmPackages.clang which ]} \
          --suffix CRYSTAL_PATH : lib:$lib/crystal \
          --suffix CRYSTAL_LIBRARY_PATH : ${
            lib.makeLibraryPath (commonBuildInputs extraBuildInputs)
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
        export LIBRARY_PATH=${lib.makeLibraryPath checkInputs}:$LIBRARY_PATH
        export PATH=${lib.makeBinPath checkInputs}:$PATH
      '';

      passthru.buildBinary = binary;
      passthru.buildCrystalPackage = callPackage ./build-package.nix {
        crystal = compiler;
      };

      meta = with lib; {
        broken = stdenv.isDarwin;
        description = "A compiled language with Ruby like syntax and type inference";
        homepage = "https://crystal-lang.org/";
        license = licenses.asl20;
        maintainers = with maintainers; [ david50407 manveru peterhoeg ];
        platforms = let archNames = builtins.attrNames archs; in
          if (lib.versionOlder version "1.2.0") then remove "aarch64-darwin" archNames else archNames;
      };
    })
  );

in
rec {
  binaryCrystal_1_0 = genericBinary {
    version = "1.0.0";
    sha256s = {
      x86_64-linux = "1949argajiyqyq09824yj3wjyv88gd8wbf20xh895saqfykiq880";
      i686-linux = "0w0f4fwr2ijhx59i7ppicbh05hfmq7vffmgl7lal6im945m29vch";
      x86_64-darwin = "01n0rf8zh551vv8wq3h0ifnsai0fz9a77yq87xx81y9dscl9h099";
      aarch64-linux = "0sns7l4q3z82qi3dc2r4p63f4s8hvifqzgq56ykwyrvawynjhd53";
    };
  };

  binaryCrystal_1_2 = genericBinary {
    version = "1.2.0";
    sha256s = {
      aarch64-darwin = "1hrs8cpjxdkcf8mr9qgzilwbg6bakq87sd4yydfsk2f4pqd6g7nf";
    };
  };

  binaryCrystal_1_5 = genericBinary {
    version = "1.5.0";
    sha256s = {
      x86_64-linux = "sha256-YnNg8PyAUgLYAxAAfVA8ei/AdFsdsiEVN9f1TpqZQ0c=";
      #i686-linux = ""; no prebuilt binaries since 1.2.0
      x86_64-darwin = "sha256-KU6+HLFlpYJSJS4F1zlHBeBt/rzxb7U57GmqRQnLm0Y==";
      #aarch64-linux = ""; not available yet
      aarch64-darwin = "sha256-KU6+HLFlpYJSJS4F1zlHBeBt/rzxb7U57GmqRQnLm0Y==";
    };
  };

  crystal_1_0 = generic {
    version = "1.0.0";
    sha256 = "sha256-RI+a3w6Rr+uc5jRf7xw0tOenR+q6qii/ewWfID6dbQ8=";
    binary = binaryCrystal_1_0;
    extraBuildInputs = [ libatomic_ops ];
  };

  crystal_1_1 = generic {
    version = "1.1.1";
    sha256 = "sha256-hhhT3reia8acZiPsflwfuD638Ll2JiXwMfES1TyGyNQ=";
    binary = crystal_1_0;
    extraBuildInputs = [ libatomic_ops ];
  };

  crystal_1_2 = generic {
    version = "1.2.2";
    sha256 = "sha256-nyOXhsutVBRdtJlJHe2dALl//BUXD1JeeQPgHU4SwiU=";
    binary = if isAarch64Darwin then binaryCrystal_1_2 else crystal_1_1;
    extraBuildInputs = [ libatomic_ops ];
  };

  crystal_1_5 = generic {
    version = "1.5.0";
    sha256 = "sha256-twDWnJBLc5tvkg3HvbxXJsCPTMJr9vGvvHvfukMXGyA=";
    binary = binaryCrystal_1_5;
  };

  crystal_1_6 = generic {
    version = "1.6.1";
    sha256 = "sha256-B6Pq2J1r+PbYT1C+2u9rNzRR5zOnbmN1/RG7mVpVHQk=";
    binary = binaryCrystal_1_5;
  };

  crystal = crystal_1_6;
}
