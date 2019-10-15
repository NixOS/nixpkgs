{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytest, mock, pytestcov, coverage
, future, futures
}:

buildPythonPackage rec {
  pname = "python-jsonrpc-server";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-jsonrpc-server";
    rev = version;
    sha256 = "054b0xm5z3f82jwp7zj21pkh7gwj9jd933jhymdx49n1n1iynfn0";
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

  propagatedBuildInputs = [ future ]
    ++ stdenv.lib.optional (pythonOlder "3.2") futures;

  meta = with stdenv.lib; {
    homepage = https://github.com/palantir/python-jsonrpc-server;
    description = "A Python 2 and 3 asynchronous JSON RPC server";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
