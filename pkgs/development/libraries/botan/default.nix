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
  esdm,
  tpm2-tss,
  static ? stdenv.hostPlatform.isStatic, # generates static libraries *only*

  # build ESDM RNG plugin
  with_esdm ? false,
  # useful, but have to disable tests for now, as /dev/tpmrm0 is not accessible
  with_tpm2 ? false,
  # only allow BSI approved algorithms, FFI and SHAKE for XMSS
  with_bsi_policy ? false,
  # only allow NIST approved algorithms
  with_fips140_policy ? false,
}:

assert (!with_bsi_policy && !with_fips140_policy) || (with_bsi_policy != with_fips140_policy);

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
        ++ lib.optionals (stdenv.hostPlatform.isLinux && with_tpm2) [
          tpm2-tss
        ]
        ++ lib.optionals (lib.versionAtLeast version "3.6.0") [
          jitterentropy
        ]
        ++ lib.optionals (lib.versionAtLeast version "3.7.0" && with_esdm) [
          esdm
        ];

      buildTargets =
        lib.optionals finalAttrs.finalPackage.doCheck [ "tests" ]
        ++ lib.optionals static [ "static" ]
        ++ lib.optionals (!static) [
          "cli"
          "shared"
        ];

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
        ++ lib.optionals (stdenv.hostPlatform.isLinux && with_tpm2) [
          "--with-tpm2"
        ]
        ++ lib.optionals (lib.versionAtLeast version "3.6.0") [
          "--enable-modules=jitter_rng"
        ]
        ++ lib.optionals (lib.versionAtLeast version "3.7.0" && with_esdm) [
          "--enable-modules=esdm_rng"
        ]
        ++ lib.optionals (lib.versionAtLeast version "3.8.0" && with_bsi_policy) [
          "--module-policy=bsi"
          "--enable-module=ffi"
          "--enable-module=shake"
        ]
        ++ lib.optionals (lib.versionAtLeast version "3.8.0" && with_fips140_policy) [
          "--module-policy=fips140"
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

      doCheck = !static;

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
    version = "3.8.1";
    hash = "sha256-sDloHUuGGi9YU3Rti6gG9VPiOGntctie2/o8Pb+hfmg=";
  };

  botan2 = common {
    version = "2.19.5";
    hash = "sha256-3+6g4KbybWckxK8B2pp7iEh62y2Bunxy/K9S21IsmtQ=";
  };
}
