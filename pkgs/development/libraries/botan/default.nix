{
  lib,
  stdenv,
  fetchurl,
  python3,
  docutils,
  bzip2,
  zlib,
  jitterentropy,
  darwin,
  static ? stdenv.hostPlatform.isStatic, # generates static libraries *only*
}:

let
  common =
    {
      version,
      hash,
      patches ? [ ],
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "botan";
      inherit version;

      __structuredAttrs = true;
      enableParallelBuilding = true;
      strictDeps = true;

      outputs = [
        "bin"
        "out"
        "dev"
        "doc"
        "man"
      ];

      src = fetchurl {
        url = "http://botan.randombit.net/releases/Botan-${finalAttrs.version}.tar.xz";
        inherit hash;
      };

      inherit patches;

      nativeBuildInputs = [
        python3
        docutils
      ];

      buildInputs =
        [
          bzip2
          zlib
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin (
          with darwin.apple_sdk.frameworks;
          [
            CoreServices
            Security
          ]
        )
        ++ lib.optionals (lib.versionAtLeast version "3.6.0") [
          jitterentropy
        ];

      buildTargets =
        [ "cli" ]
        ++ lib.optionals finalAttrs.doCheck [ "tests" ]
        ++ lib.optionals static [ "static" ]
        ++ lib.optionals (!static) [ "shared" ];

      botanConfigureFlags =
        [
          "--prefix=${placeholder "out"}"
          "--bindir=${placeholder "bin"}/bin"
          "--docdir=${placeholder "doc"}/share/doc"
          "--mandir=${placeholder "man"}/share/man"
          "--no-install-python-module"
          "--build-targets=${lib.concatStringsSep "," finalAttrs.buildTargets}"
          "--with-bzip2"
          "--with-zlib"
          "--with-rst2man"
          "--cpu=${stdenv.hostPlatform.parsed.cpu.name}"
        ]
        ++ lib.optionals stdenv.cc.isClang [
          "--cc=clang"
        ]
        ++ lib.optionals (lib.versionAtLeast version "3.6.0") [
          "--enable-modules=jitter_rng"
        ];

      configurePhase = ''
        runHook preConfigure
        python configure.py ''${botanConfigureFlags[@]}
        runHook postConfigure
      '';

      preInstall = ''
        if [ -d src/scripts ]; then
          patchShebangs src/scripts
        fi
      '';

      postInstall = ''
        cd "$out"/lib/pkgconfig
        ln -s botan-*.pc botan.pc || true
      '';

      doCheck = true;

      meta = with lib; {
        description = "Cryptographic algorithms library";
        homepage = "https://botan.randombit.net";
        mainProgram = "botan";
        maintainers = with maintainers; [
          raskin
          thillux
        ];
        platforms = platforms.unix;
        license = licenses.bsd2;
      };
    });
in
{
  botan3 = common {
    version = "3.6.1";
    hash = "sha256-fLhXXYjSMsdxdHadf54ku0REQWBYWYbuvWbnScuakIk=";
    # this patch fixes build errors on MacOS with SDK 10.12, recheck to remove this again
    patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./botan3-macos.patch ];
  };

  botan2 = common {
    version = "2.19.5";
    hash = "sha256-3+6g4KbybWckxK8B2pp7iEh62y2Bunxy/K9S21IsmtQ=";
  };
}
