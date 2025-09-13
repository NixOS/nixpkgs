{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodomex,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dsinternals";
  version = "1.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "pydsinternals";
    rev = version;
    hash = "sha256-C1ar9c4F4WI5ICX7PJe8FzVwK8bxZds+kMBpttEp9Ko=";
  };

  propagatedBuildInputs = [
    pyopenssl
    pycryptodomex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dsinternals" ];

  enabledTestPaths = [ "tests/*.py" ];

  meta = with lib; {
    description = "Module to interact with Windows Active Directory";
    homepage = "https://github.com/p0dalirius/pydsinternals";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
