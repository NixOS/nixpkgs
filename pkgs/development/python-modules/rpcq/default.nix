{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, numpy
, pytest-asyncio
, pytestCheckHook
, python-rapidjson
, pythonOlder
, pyzmq
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "rpcq";
  version = "3.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-J7jtGXJIF3jp0a0IQZmSR4TWf9D02Luau+Bupmi/d68=";
  };

  propagatedBuildInputs = [
    msgpack
    python-rapidjson
    pyzmq
    ruamel-yaml
  ];

  checkInputs = [
    numpy
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "msgpack>=0.6,<1.0" "msgpack"
  '';

  disabledTests = [
    # Test doesn't work properly on Hydra
    "test_client_backlog"
  ];

  pythonImportsCheck = [
    "rpcq"
  ];

  meta = with lib; {
    description = "The RPC framework and message specification for rigetti Quantum Cloud services";
    homepage = "https://github.com/rigetti/rpcq";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
