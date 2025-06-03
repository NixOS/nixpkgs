{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  typing-extensions,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "asserts";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "srittau";
    repo = "python-asserts";
    tag = "v${version}";
    hash = "sha256-hjTzGCcURI0NH9pgZ6KB0J3tSbgIaneDnWr8zrLVG6M=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    typing-extensions
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "asserts"
  ];

  meta = {
    description = "Stand-alone Assertions for Python";
    homepage = "https://github.com/srittau/python-asserts";
    changelog = "https://github.com/srittau/python-asserts/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
