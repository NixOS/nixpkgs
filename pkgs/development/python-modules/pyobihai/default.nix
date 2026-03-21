{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "pyobihai";
  version = "1.4.2";
  format = "setuptools";

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

  meta = {
    description = "Module to interact with Obihai devices";
    homepage = "https://github.com/ejpenney/pyobihai";
    changelog = "https://github.com/ejpenney/pyobihai/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
