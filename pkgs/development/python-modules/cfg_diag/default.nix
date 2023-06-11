{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, setuptools
}:

let
  cfg_diag = buildPythonPackage rec {
    pname = "cfg_diag";
    version = "0.4.0";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "storpool";
      repo = "python-cfg_diag";
      rev = "release/${version}";
      sha256 = "y9g/0JzbeF1gab/HaTfKj1AtAdcY6LO1aeEn+A2Ms/s=";
    };

    meta = with lib; {
      homepage = "https://github.com/storpool/python-cfg_diag";
      description = "A common configuration-storage class with a .diag() method";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ppentchev ];
    };

    propagatedBuildInputs = [
      setuptools
    ];

    checkInputs = [
      pytestCheckHook
    ];
    pythonImportsCheck = [ "cfg_diag" ];
  };
in
cfg_diag
