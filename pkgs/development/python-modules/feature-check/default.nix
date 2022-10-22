{ buildPythonPackage
, fetchFromGitLab
, lib
, pyparsing
, pytestCheckHook
, setuptools
}:

let
  feature-check = buildPythonPackage rec {
    pname = "feature-check";
    version = "2.0.0";
    format = "pyproject";

    src = fetchFromGitLab {
      owner = "ppentchev";
      repo = "feature-check";
      rev = "release/${version}";
      sha256 = "Qx3NGSVbgTZb6/VbsVWu4oaSusEuy81eW3lka/umu2E=";
    };

    sourceRoot = "source/python";

    meta = with lib; {
      homepage = "https://devel.ringlet.net/misc/feature-check/";
      description = "Query a program for supported features";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ppentchev ];
    };

    propagatedBuildInputs = [
      pyparsing
      setuptools
    ];

    checkInputs = [
      pytestCheckHook
    ];
    pythonImportsCheck = [ "feature_check" ];
  };
in
feature-check
