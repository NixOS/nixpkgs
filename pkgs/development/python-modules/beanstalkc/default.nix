{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "beanstalkc";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98978e57797320146f4b233286d9a02f65d20bad0168424118839fc608085280";
  };

  meta = {
    description = "A simple beanstalkd client library for Python";
    maintainers = with stdenv.lib.maintainers; [ aanderse ];
    license = with stdenv.lib.licenses; [ asl20 ];
    homepage = https://github.com/earl/beanstalkc;
  };
}
