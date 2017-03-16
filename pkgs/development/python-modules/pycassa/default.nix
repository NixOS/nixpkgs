{ stdenv, buildPythonPackage, fetchurl, thrift, isPy3k }:

buildPythonPackage rec {
  version = "1.11.2";
  name = "pycassa-${version}";
  src = fetchurl {
    url = "mirror://pypi/p/pycassa/${name}.tar.gz";
    sha256 = "1nsqjzgn6v0rya60dihvbnrnq1zwaxl2qwf0sr08q9qlkr334hr6";
  };

  disabled = isPy3k;

  # Tests are not executed since they require a cassandra up and
  # running
  doCheck = false;

  propagatedBuildInputs = [ thrift ];

  meta = {
    description = "pycassa is a python client library for Apache Cassandra";
    homepage = http://github.com/pycassa/pycassa;
    license = stdenv.licenses.mit;
  };
}
