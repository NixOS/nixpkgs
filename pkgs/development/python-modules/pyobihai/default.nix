{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pyobihai";
  version = "1.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ejpenney";
    repo = "pyobihai";
    tag = version;
    hash = "sha256-tDPu/ceH7+7AnxokADDfl+G56B0+ri8RxXxXEyWa61Q=";
  };

  propagatedBuildInputs = [
    defusedxml
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyobihai" ];

  meta = with lib; {
    description = "Module to interact with Obihai devices";
    homepage = "https://github.com/ejpenney/pyobihai";
    changelog = "https://github.com/ejpenney/pyobihai/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
