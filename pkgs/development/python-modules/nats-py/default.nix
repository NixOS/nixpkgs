{ lib
, stdenv
, aiohttp
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
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-w+YySX9RNXUttt7iLg/Efh8bNzmhIQTKMXcoPO1k4lI=";
  };

  propagatedBuildInputs = [
    aiohttp
    ed25519
  ];

  nativeCheckInputs = [
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
    "test_stream_management"
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
    changelog = "https://github.com/nats-io/nats.py/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
