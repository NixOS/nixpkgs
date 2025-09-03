{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pyasn1,
  pyasn1-modules,
  cryptography,
  joblib,
  gitpython,
  sqlalchemy,
  pygount,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "edk2-pytool-library";
  version = "0.23.8";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2-pytool-library";
    tag = "v${version}";
    hash = "sha256-JSOijiH/de/bItNt7yNu8+P21rI7YqiTf54zV2Ij5Gs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyasn1
    pyasn1-modules
    cryptography
    joblib
    gitpython
    sqlalchemy
    pygount
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # requires network access
    "test_basic_parse"
  ];

  pythonImportsCheck = [ "edk2toollib" ];

  meta = with lib; {
    description = "Python library package that supports UEFI development";
    homepage = "https://github.com/tianocore/edk2-pytool-library";
    changelog = "https://github.com/tianocore/edk2-pytool-library/releases/tag/${src.tag}";
    license = licenses.bsd2Patent;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.linux;
  };
}
