{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k, more-itertools
, atomicwrites, mock, writeText, pathlib2
}:

let generic = { version, sha256 }: let

  # runTests is a function that returns a string that can be used as a checkPhase.
  runTests = with stdenv.lib; {
    disabledTests ? [],     # Disable tests that match expression.
    disabledTestIds ? [],   # Disable tests that match given node id's. This is useful in case a test in a specific file needs to be disabled.
    options ? [],           # py.test options.
    targets ? [],           # py.test files or folders.
    variables ? {},         # Environment variables to export.
  }: let
    varsString = concatStringsSep " " (mapAttrsToList (var: value: "${var}=${value}") variables);
    disabledTestsString = optionalString (disabledTests != []) "-k '${concatMapStringsSep " and " (s: "not " + s) disabledTests}'";
    disabledTestIdsString = optionalString (disabledTestIds != []) "--deselect=$(concatStringsSep ',' disabledTestIds}";
    invocation = concatStringsSep " " [
      varsString
      "py.test"
      disabledTestsString
      disabledTestIdsString
      (concatStringsSep " " options)
      (concatStringsSep " " targets)
    ];
  in ''
    runHook preCheck
    echo "Running tests using: ${invocation}"
    ${invocation}
    runHook postCheck
  '';

  pytest = buildPythonPackage rec {
    pname = "pytest";
    inherit version;

    preCheck = ''
      # don't test bash builtins
      rm testing/test_argcomplete.py
    '';

    src = fetchPypi {
      inherit pname version sha256;
    };

    checkInputs = [ hypothesis mock ];
    buildInputs = [ setuptools_scm ];
    propagatedBuildInputs = [ attrs py setuptools six pluggy more-itertools atomicwrites]
      ++ stdenv.lib.optionals (!isPy3k) [ funcsigs ]
      ++ stdenv.lib.optionals (pythonOlder "3.6") [ pathlib2 ];

    checkPhase = ''
      runHook preCheck
      $out/bin/py.test -x testing/
      runHook postCheck
    '';

    # Remove .pytest_cache when using py.test in a Nix build
    setupHook = writeText "pytest-hook" ''
      pytestcachePhase() {
          find $out -name .pytest_cache -type d -exec rm -rf {} +
      }

      preDistPhases+=" pytestcachePhase"
    '';

    passthru.runTests = runTests;

    meta = with stdenv.lib; {
      homepage = https://docs.pytest.org;
      description = "Framework for writing tests";
      maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
      license = licenses.mit;
    };
  };
  in pytest;

in {
  pytest_39 = generic {
    version = "3.9.3";
    sha256 = "a9e5e8d7ab9d5b0747f37740276eb362e6a76275d76cebbb52c6049d93b475db";
  };

  pytest_37 = generic {
    version = "3.7.4";
    sha256 = "2d7c49e931316cc7d1638a3e5f54f5d7b4e5225972b3c9838f3584788d27f349";
  };
}
