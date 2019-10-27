{ stdenv, buildPythonPackage, fetchPypi, thrift, isPy3k }:

let

  thrift' = thrift.overridePythonAttrs (old: rec {
    version = "0.9.3";
    src= fetchPypi {
      inherit (old) pname;
      inherit version;
      sha256 = "0zl7cgckqy9j5vq8wyfzw82q1blkdpsblnmhv8c6ffcxs4xkvg6z";
    };
  });

in

buildPythonPackage rec {
  pname = "pycassa";
  version = "1.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nsqjzgn6v0rya60dihvbnrnq1zwaxl2qwf0sr08q9qlkr334hr6";
  };

  disabled = isPy3k;

  # Tests are not executed since they require a cassandra up and
  # running
  doCheck = false;

  propagatedBuildInputs = [ thrift' ];

  meta = {
    description = "A python client library for Apache Cassandra";
    homepage = https://github.com/pycassa/pycassa;
    license = stdenv.lib.licenses.mit;
  };
}
