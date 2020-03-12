{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytest, mock, pytestcov, coverage
, future, futures, ujson
}:

buildPythonPackage rec {
  pname = "python-jsonrpc-server";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-jsonrpc-server";
    rev = version;
    sha256 = "sha256:027sx5pv4i9a192kr00bjjcxxprh2xyr8q5372q8ghff3xryk9dd";
  };

  postPatch = ''
    sed -i 's/version=versioneer.get_version(),/version="${version}",/g' setup.py
  '';

  checkInputs = [
    pytest mock pytestcov coverage
  ];

  checkPhase = ''
    pytest
  '';

  propagatedBuildInputs = [ future ujson ]
    ++ stdenv.lib.optional (pythonOlder "3.2") futures;

  meta = with stdenv.lib; {
    homepage = https://github.com/palantir/python-jsonrpc-server;
    description = "A Python 2 and 3 asynchronous JSON RPC server";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
