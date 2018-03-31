{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "avro";
  version = "1.7.6";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mbsf1y7gnzmnfmqh8aw62yrwnpwm5bhmmkkbbq92a5vr91l3wgd";
  };

  meta = with stdenv.lib; {
    description = "A serialization and RPC framework";
    homepage = https://pypi.python.org/pypi/avro/;
  };
}
