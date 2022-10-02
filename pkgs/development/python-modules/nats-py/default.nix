{ lib
, stdenv
, buildPythonPackage
, ed25519
, fetchFromGitHub
, nats-server
, pytestCheckHook
, pythonOlder
, uvloop
}:

buildPythonPackage rec {
  pname = "nats-py";
  version = "2.1.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-K2ugTwfeYrdBnXFV9SHNQP+fNvUmc1yuy53gpGmmvS0=";
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
    # AssertionError: assert 5 == 0
    "test_pull_subscribe_limits"
    "test_fetch_n"
    "test_subscribe_no_echo"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_subscribe_iterate_next_msg"
    "test_buf_size_force_flush_timeout"
  ];

  pythonImportsCheck = [
    "nats"
  ];

  meta = with lib; {
    description = "Python client for NATS.io";
    homepage = "https://github.com/nats-io/nats.py";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
