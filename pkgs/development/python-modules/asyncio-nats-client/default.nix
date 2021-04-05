{ lib
, buildPythonPackage
, ed25519
, fetchFromGitHub
, nats-server
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncio-nats-client";
  version = "0.11.4";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats.py";
    rev = "v${version}";
    sha256 = "1aj57xi2rj1xswq8air13xdsll1ybpi0nmz5f6jq01azm0zy9xyd";
  };

  propagatedBuildInputs = [
    ed25519
  ];

  checkInputs = [
    nats-server
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=nats --cov-report html" ""
  '';

  disabledTests = [
    # RuntimeError: Event loop is closed
    "test_subscribe_no_echo"
    "test_reconnect_to_new_server_with_auth"
  ];

  pythonImportsCheck = [ "nats.aio" ];

  meta = with lib; {
    description = "Python client for NATS.io";
    homepage = "https://github.com/nats-io/nats.py";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
