{ stdenv, buildPythonPackage, fetchPypi, pytest, jsonschema, funcsigs, apply-defaults, mypy, six
}:

buildPythonPackage rec {
  pname = "jsonrpcserver";
  version = "3.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8442af3632ebf012c773aea78639e1ad3f605cda2ffcc58d6e4e34ecf8b4a167";
  };

  propagatedBuildInputs = [ apply-defaults jsonschema funcsigs six ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/bcb/jsonrpcserver;
    description = "Process JSON-RPC requests in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jb55 ];
  };
}
