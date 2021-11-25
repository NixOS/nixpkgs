{ lib
, buildPythonPackage
, ed25519
, fetchFromGitHub
, nats-server
, pytestCheckHook
, pythonOlder
, uvloop
}:

buildPythonPackage rec {
  pname = "asyncio-nats-client";
  version = "0.11.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats.py";
    rev = "v${version}";
    sha256 = "sha256-UCDZpdcQxlFF5xt4iOKrjpRuzbqt4tjCmc1VrpWMkX8=";
  };

  propagatedBuildInputs = [
    ed25519
  ];

  checkInputs = [
    nats-server
    pytestCheckHook
    uvloop
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=nats --cov-report html" ""
  '';

  disabledTests = [
    # RuntimeError: Event loop is closed
    "test_subscribe_no_echo"
    "test_kv_simple"
  ];

  pythonImportsCheck = [
    "nats.aio"
  ];

  meta = with lib; {
    description = "Python client for NATS.io";
    homepage = "https://github.com/nats-io/nats.py";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
