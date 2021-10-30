{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, aria2, poetry, pytest, pytest-cov, pytest-xdist, responses
, asciimatics, loguru, requests, setuptools, websocket-client
}:

buildPythonPackage rec {
  pname = "aria2p";
  version = "0.9.1";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pawamoy";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s4kad6jnfz9p64gkqclkfq2x2bn8dbc0hyr86d1545bgn7pz672";
  };

  nativeBuildInputs = [ poetry ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [ aria2 responses pytest pytest-cov pytest-xdist ];

  # Tests are not all stable/deterministic,
  # they rely on actually running an aria2c daemon and communicating with it,
  # race conditions and deadlocks were observed,
  # thus the corresponding tests are disabled
  checkPhase = ''
    pytest -nauto -k "not test_api and not test_cli and not test_interface"
  '';

  propagatedBuildInputs = [ asciimatics loguru requests setuptools websocket-client ];

  meta = with lib; {
    homepage = "https://github.com/pawamoy/aria2p";
    description = "Command-line tool and library to interact with an aria2c daemon process with JSON-RPC";
    license = licenses.isc;
    maintainers = with maintainers; [ koral ];
  };
}
