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
    tag = "v${version}";
    hash = "sha256-QwjwuXjaxE1Y+Jzn8hJXY4wKltAT8mdOM7jJ9MF+DhA=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiorwlock" ];

<<<<<<< HEAD
  meta = {
    description = "Read write lock for asyncio";
    homepage = "https://github.com/aio-libs/aiorwlock";
    changelog = "https://github.com/aio-libs/aiorwlock/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ billhuang ];
=======
  meta = with lib; {
    description = "Read write lock for asyncio";
    homepage = "https://github.com/aio-libs/aiorwlock";
    changelog = "https://github.com/aio-libs/aiorwlock/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
