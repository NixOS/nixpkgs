{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "configobj";
  version = "5.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DiffSK";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-t3Q0FEBibkAM5PAG4fjXwNH/71RqSSDj/Mn27ri0iDU=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ mock ];

  pythonImportsCheck = [ "configobj" ];

  meta = with lib; {
    description = "Config file reading, writing and validation";
    homepage = "https://github.com/DiffSK/configobj";
    changelog = "https://github.com/DiffSK/configobj/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
