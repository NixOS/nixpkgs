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
  version = "0.21.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2-pytool-library";
    rev = "refs/tags/v${version}";
    hash = "sha256-4Sb8Lu/nYUXgGt9gVv+j32cwW7TjXfH8z+fwzKaOeM8=";
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
    changelog = "https://github.com/tianocore/edk2-pytool-library/releases/tag/v${version}";
    license = licenses.bsd2Patent;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.linux;
  };
}
