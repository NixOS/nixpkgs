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
  version = "2.2.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "15f08czqfmxy1y947rlrsjs20jgsy2vc1wqhv4b08b3ijxj0jpqh";
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
