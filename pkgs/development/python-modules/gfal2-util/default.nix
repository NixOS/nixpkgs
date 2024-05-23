{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  runCommandLocal,
  # Build inputs
  gfal2-python,
  # For tests
  xrootd, # pkgs.xrootd
}:
(buildPythonPackage rec {
  pname = "gfal2-util";
  version = "1.8.1";
  src = fetchFromGitHub {
    owner = "cern-fts";
    repo = "gfal2-util";
    rev = "v${version}";
    hash = "sha256-3JbJgKD17aYkrB/aaww7IQU8fLFrTCh868KWlLPxmlk=";
  };

  # Replace the ad-hoc python executable finding
  # and change the shebangs from `#!/bin/sh` to `#!/usr/bin/env python`
  # for fixup phase to work correctly.
  postPatch = ''
    for script in src/gfal-*; do
      patch "$script" ${./gfal-util-script.patch}
    done
  '';

  propagatedBuildInputs = [ gfal2-python ];

  pythonImportsCheck = [ "gfal2_util" ];

  meta = with lib; {
    description = "CLI for gfal2";
    homepage = "https://github.com/cern-fts/gfal2-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}).overrideAttrs
  (
    finalAttrs: previousAttrs:
    lib.recursiveUpdate previousAttrs {
      passthru = {
        inherit (gfal2-python) gfal2;

        fetchGfal2 = lib.makeOverridable (
          callPackage ./fetchgfal2.nix { gfal2-util = finalAttrs.finalPackage; }
        );

        # With these functionality tests, it should be safe to merge version bumps once all the tests are passed.
        tests =
          let
            # Use the the bin output hash of gfal2-util as version to ensure that
            # the test gets rebuild everytime gfal2-util gets rebuild
            versionFODTests =
              finalAttrs.version + "-" + lib.substring (lib.stringLength builtins.storeDir + 1) 32 "${self}";
            self = finalAttrs.finalPackage;
          in
          lib.optionalAttrs gfal2-python.gfal2.enablePluginStatus.xrootd (
            let
              # Test against a real-world dataset from CERN Open Data
              # borrowed from `xrootd.tests`.
              urlTestFile = xrootd.tests.test-xrdcp.url;
              hashTestFile = xrootd.tests.test-xrdcp.outputHash;
              urlTestDir = dirOf urlTestFile;
            in
            {
              test-copy-file-xrootd = finalAttrs.passthru.fetchGfal2 {
                url = urlTestFile;
                hash = hashTestFile;
                extraGfalCopyFlags = [ "--verbose" ];
                pname = "gfal2-util-test-copy-file-xrootd";
                version = versionFODTests;
                allowSubstitutes = false;
              };

              test-copy-dir-xrootd = finalAttrs.passthru.fetchGfal2 {
                url = urlTestDir;
                hash = "sha256-vOahIhvx1oE9sfkqANMGUvGeLHS737wyfYWo4rkvrxw=";
                recursive = true;
                extraGfalCopyFlags = [ "--verbose" ];
                pname = "gfal2-util-test-copy-dir-xrootd";
                version = versionFODTests;
                allowSubstitutes = false;
              };

              test-ls-dir-xrootd =
                (runCommandLocal "test-gfal2-util-ls-dir-xrootd" { } ''
                  set -eu -o pipefail
                  gfal-ls "$url" | grep "$baseNameExpected" | tee "$out"
                '').overrideAttrs
                  (
                    finalAttrs: previousAttrs: {
                      pname = previousAttrs.name;
                      version = versionFODTests;
                      name = "${finalAttrs.pname}-${finalAttrs.version}";
                      nativeBuildInputs = [ self ];
                      url = urlTestDir;
                      baseNameExpected = baseNameOf urlTestFile;
                      outputHashMode = "flat";
                      outputHashAlgo = "sha256";
                      outputHash = builtins.hashString finalAttrs.outputHashAlgo (finalAttrs.baseNameExpected + "\n");
                    }
                  );
            }
          );
      };
    }
  )
