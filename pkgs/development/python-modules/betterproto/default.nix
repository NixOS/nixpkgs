{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pythonOlder,
  poetry-core,
  grpclib,
  python-dateutil,
  black,
  jinja2,
  isort,
  python,
  pydantic,
  pytest7CheckHook,
  pytest-asyncio_0_21,
  pytest-mock,
  typing-extensions,
  tomlkit,
  grpcio-tools,
}:

buildPythonPackage rec {
  pname = "betterproto";
  version = "2.0.0b6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "python-betterproto";
    tag = "v.${version}";
    hash = "sha256-ZuVq4WERXsRFUPNNTNp/eisWX1MyI7UtwqEI8X93wYI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry-core>=1.0.0,<2" "poetry-core"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    grpclib
    python-dateutil
    typing-extensions
  ];

  optional-dependencies.compiler = [
    black
    jinja2
    isort
  ];

  nativeCheckInputs = [
    grpcio-tools
    pydantic
    pytest-asyncio_0_21
    pytest-mock
    pytest7CheckHook
    tomlkit
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "betterproto" ];

  # The tests require the generation of code before execution. This requires
  # the protoc-gen-python_betterproto script from the package to be on PATH.
  preCheck = ''
    (($(ulimit -n) < 1024)) && ulimit -n 1024
    export PATH=$PATH:$out/bin
    patchShebangs src/betterproto/plugin/main.py
    ${python.interpreter} -m tests.generate
  '';

  disabledTestPaths = [
    # https://github.com/danielgtaylor/python-betterproto/issues/530
    "tests/inputs/oneof/test_oneof.py"
  ];

  disabledTests = [
    "test_pydantic_no_value"
    # Test is flaky
    "test_binary_compatibility"
  ];

  meta = {
    description = "Code generator & library for Protobuf 3 and async gRPC";
    mainProgram = "protoc-gen-python_betterproto";
    longDescription = ''
      This project aims to provide an improved experience when using Protobuf /
      gRPC in a modern Python environment by making use of modern language
      features and generating readable, understandable, idiomatic Python code.
    '';
    homepage = "https://github.com/danielgtaylor/python-betterproto";
    changelog = "https://github.com/danielgtaylor/python-betterproto/blob/v.${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nikstur ];
  };
}
