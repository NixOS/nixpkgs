{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, aria2, poetry, pytest, pytestcov, pytest_xdist, responses
, asciimatics, loguru, requests, setuptools, websocket_client
}:

buildPythonPackage rec {
  pname = "aria2p";
  version = "0.7.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pawamoy";
    repo = pname;
    rev = "v${version}";
    sha256 = "1inak3y2win58zbzykfzy6xp00f276sqsz69h2nfsd93mpr74wf6";
  };
  
  nativeBuildInputs = [ poetry ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [ aria2 responses pytest pytestcov pytest_xdist ];

  # Tests are not all stable/deterministic,
  # they rely on actually running an aria2c daemon and communicating with it,
  # race conditions and deadlocks were observed,
  # thus the corresponding tests are disabled
  checkPhase = ''
    pytest -nauto -k "not test_api and not test_cli and not test_interface"
  '';

  propagatedBuildInputs = [ asciimatics loguru requests setuptools websocket_client ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/pawamoy/aria2p";
    description = "Command-line tool and library to interact with an aria2c daemon process with JSON-RPC";
    license = licenses.isc;
    maintainers = with maintainers; [ koral ];
  };
}
