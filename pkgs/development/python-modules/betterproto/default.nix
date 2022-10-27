{ buildPythonPackage
, fetchFromGitHub
, lib
, pythonOlder
, poetry-core
, grpclib
, python-dateutil
, dataclasses
, black
, jinja2
, isort
, python
, pytestCheckHook
, pytest-asyncio
, pytest-mock
, tomlkit
, grpcio-tools
}:

buildPythonPackage rec {
  pname = "betterproto";
  version = "2.0.0b5";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "python-betterproto";
    rev = "v${version}";
    sha256 = "sha256-XyXdpo3Yo4aO1favMWC7i9utz4fNDbKbsnYXJW0b7Gc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    grpclib
    python-dateutil
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ];

  passthru.optional-dependencies.compiler = [
    black
    jinja2
    isort
  ];

  pythonImportsCheck = [ "betterproto" ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    tomlkit
    grpcio-tools
  ] ++ passthru.optional-dependencies.compiler;

  # The tests require the generation of code before execution. This requires
  # the protoc-gen-python_betterproto script from the packge to be on PATH.
  preCheck = ''
    export PATH=$PATH:$out/bin
    ${python.interpreter} -m tests.generate
  '';

  meta = with lib; {
    description = "Clean, modern, Python 3.6+ code generator & library for Protobuf 3 and async gRPC";
    longDescription = ''
      This project aims to provide an improved experience when using Protobuf /
      gRPC in a modern Python environment by making use of modern language
      features and generating readable, understandable, idiomatic Python code.
    '';
    homepage = "https://github.com/danielgtaylor/python-betterproto";
    license = licenses.mit;
    maintainers = with maintainers; [ nikstur ];
  };
}
