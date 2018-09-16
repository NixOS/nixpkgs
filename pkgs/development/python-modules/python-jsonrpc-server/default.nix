{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytest, mock, pytestcov, coverage
, future, futures
}:

buildPythonPackage rec {
  pname = "python-jsonrpc-server";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-jsonrpc-server";
    rev = version;
    sha256 = "0p5dj1hxx3yz8vjk59dcp3h6ci1hrjkbzf9lr3vviy0xw327409k";
  };

  checkInputs = [
    pytest mock pytestcov coverage
  ];

  checkPhase = ''
    pytest
  '';

  propagatedBuildInputs = [ future ]
    ++ stdenv.lib.optional (pythonOlder "3.2") futures;

  meta = with stdenv.lib; {
    homepage = https://github.com/palantir/python-jsonrpc-server;
    description = "A Python 2 and 3 asynchronous JSON RPC server";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
