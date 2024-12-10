{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiorwlock";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiorwlock";
    rev = "refs/tags/v${version}";
    hash = "sha256-QwjwuXjaxE1Y+Jzn8hJXY4wKltAT8mdOM7jJ9MF+DhA=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiorwlock" ];

  meta = with lib; {
    description = "Read write lock for asyncio";
    homepage = "https://github.com/aio-libs/aiorwlock";
    changelog = "https://github.com/aio-libs/aiorwlock/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
  };
}
