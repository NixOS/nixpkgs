{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, pythonRelaxDepsHook
, pyasn1
, pyasn1-modules
, cryptography
, tinydb
, joblib
, tinyrecord
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "edk2-pytool-library";
  version = "0.17.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2-pytool-library";
    rev = "v${version}";
    hash = "sha256-US9m7weW11+VxX6ZsKP5tYKp+bQoiI+TZ3YWE97D/f0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "tinydb"
    "joblib"
  ];

  propagatedBuildInputs = [
    pyasn1
    pyasn1-modules
    cryptography
    tinydb
    joblib
    tinyrecord
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonImportsCheck = [ "edk2toollib" ];

  meta = with lib; {
    description = "Python library package that supports UEFI development";
    homepage = "https://github.com/tianocore/edk2-pytool-library";
    changelog = "https://github.com/tianocore/edk2-pytool-library/releases/tag/v${version}";
    license = licenses.bsd2Patent;
    maintainers = with maintainers; [ nickcao ];
  };
}
