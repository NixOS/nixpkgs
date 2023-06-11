{ buildPythonPackage
, fetchPypi
, lib
, setuptools
}:

let
  contextlib-chdir = buildPythonPackage rec {
    pname = "contextlib-chdir";
    version = "1.0.2";
    format = "pyproject";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-WEBqcdsAZH/Mz8flLp4E5E0p6s8wQA58C6OxXwnV8/o=";
    };

    patches = [
      ./setup-no-packages.patch
    ];

    meta = with lib; {
      description = "Backport of contextlib.chdir stdlib class added in Python3.11";
      license = licenses.bsd3;
      maintainers = with maintainers; [ ppentchev ];
    };

    propagatedBuildInputs = [
      setuptools
    ];

    pythonImportsCheck = [ "contextlib_chdir" ];
  };
in
contextlib-chdir
