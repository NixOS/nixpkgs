{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "edk2-pytool-library";
  version = "0.14.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2-pytool-library";
    rev = "v${version}";
    hash = "sha256-l3ZM2xxZrFz7n/uLSd994l+mGJDi4Qw4C2Lg2uyttL8=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonImportsCheck = [ "edk2toollib" ];

  meta = with lib; {
    description = "Python library package that supports UEFI development";
    homepage = "https://github.com/tianocore/edk2-pytool-library";
    license = licenses.bsd2Patent;
    maintainers = with maintainers; [ nickcao ];
  };
}
