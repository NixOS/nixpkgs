{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  msgpack,
  numpy,
  pytest-asyncio,
  pytestCheckHook,
  python-rapidjson,
  pythonOlder,
  pyzmq,
  ruamel-yaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rpcq";
  version = "3.10.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "rpcq";
    rev = "refs/tags/v${version}";
    hash = "sha256-J7jtGXJIF3jp0a0IQZmSR4TWf9D02Luau+Bupmi/d68=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "msgpack>=0.6,<1.0" "msgpack"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    msgpack
    python-rapidjson
    pyzmq
    ruamel-yaml
  ];

  nativeCheckInputs = [
    numpy
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # Don't run tests that spin-up a zmq server
    "rpcq/test/test_base.py"
    "rpcq/test/test_spec.py"
  ];

  pythonImportsCheck = [ "rpcq" ];

  meta = with lib; {
    description = "The RPC framework and message specification for rigetti Quantum Cloud services";
    homepage = "https://github.com/rigetti/rpcq";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
