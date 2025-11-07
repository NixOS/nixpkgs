{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  grpclib,
  python-dateutil,
  black,
  jinja2,
  isort,
  python,
  cachelib,
  pydantic,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
  typing-extensions,
  tomlkit,
  grpcio-tools,
}:

buildPythonPackage rec {
  pname = "betterproto";
  version = "2.0.0b7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "python-betterproto";
    tag = "v.${version}";
    hash = "sha256-T7QSPH8MFa1hxJOhXc3ZMM62/FxHWjCJJ59IpeM41rI=";
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
    cachelib
    grpcio-tools
    pydantic
    pytest-asyncio
    pytest-mock
    pytestCheckHook
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

  disabledTests = [
    # incompatible with pytest 8:
    #     TypeError: exceptions must be derived from Warning, not <class 'NoneType'>
    "test_message_with_deprecated_field_not_set"
    "test_service_with_deprecated_method"
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
