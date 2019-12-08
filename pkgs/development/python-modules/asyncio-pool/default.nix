{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, pytest-asyncio
, async-timeout
}:

buildPythonPackage rec {
  pname = "asyncio-pool";
  version = "0.5.1";

  src = fetchPypi {
    pname = "asyncio_pool";
    inherit version;
    sha256 = "06ygc7g8hpzgwv91ic7v5vsaqr725dnwh4ysbrj91yppaq1djz5c";
  };

  checkInputs = [
    pytest
    pytest-asyncio
    async-timeout
  ];

  checkPhase = ''
    pytest tests
  '';

  # tarball missing tests
  # https://github.com/gistart/asyncio-pool/issues/2
  doCheck = false;

  disabled = pythonOlder "3.5";

  meta = with stdenv.lib; {
    description = "Pool for asyncio with multiprocessing, threading and gevent-like interface";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
