{ lib
, appdirs
, buildPythonPackage
, fetchFromGitHub
, platformdirs
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "platformdirs";
  version = "2.4.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-Ox1CVq2M2eddZtpuZx0IfvuOm6RPsAs27WkMdZSeh0E=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    appdirs
    pytest-mock
    pytestCheckHook
  ];

 pythonImportsCheck = [ "platformdirs" ];

  meta = with lib; {
    description = "Python module for determining appropriate platform-specific directories";
    homepage = "https://platformdirs.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
