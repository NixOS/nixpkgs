{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytest-asyncio,
  pytest-timeout,
  responses,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pyvera";
  version = "0.3.16";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "pavoni";
    repo = "pyvera";
    tag = version;
    hash = "sha256-WLzVOQEykST2BsVRHmcBhrsd/am0jI/f7D0PmpCTbdQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytest-cov-stub
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "pyvera" ];

  meta = with lib; {
    description = "Python library to control devices via the Vera hub";
    homepage = "https://github.com/pavoni/pyvera";
    changelog = "https://github.com/maximvelichko/pyvera/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
