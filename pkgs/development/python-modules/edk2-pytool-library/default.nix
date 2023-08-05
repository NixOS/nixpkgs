{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, pyasn1
, pyasn1-modules
, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "edk2-pytool-library";
  version = "0.15.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2-pytool-library";
    rev = "v${version}";
    hash = "sha256-jGZa1qfI/OybwgG2L4N1hICHpWZTufgElpl31EhU+O4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyasn1
    pyasn1-modules
    cryptography
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
