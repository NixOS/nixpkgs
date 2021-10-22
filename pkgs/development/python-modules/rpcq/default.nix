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
  version = "3.9.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vvf6y7459f8aamhkcxx36ajiai143s2vwg751x0dl0lx7hp3yn5";
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

  pythonImportsCheck = [ "rpcq" ];

  meta = with lib; {
    description = "The RPC framework and message specification for rigetti Quantum Cloud services";
    homepage = "https://github.com/rigetti/rpcq";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
