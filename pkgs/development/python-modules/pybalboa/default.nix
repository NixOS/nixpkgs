{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  pytest-asyncio_0,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pybalboa";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garbled1";
    repo = "pybalboa";
    # missing tag: https://github.com/garbled1/pybalboa/issues/100
    rev = "6aa7e3c401ab03b93c083acdf430afb708e20e9b";
    hash = "sha256-xOMbMmTTDDbd0WL0LFJ6lztsQMdI/r9MLhV9DmB6m3I=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytestCheckHook
  ];

  disabledTests = [
    # async def functions are not natively supported.
    "test_cancel_task"
  ];

  pythonImportsCheck = [ "pybalboa" ];

  meta = with lib; {
    description = "Module to communicate with a Balboa spa wifi adapter";
    homepage = "https://github.com/garbled1/pybalboa";
    changelog = "https://github.com/garbled1/pybalboa/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
