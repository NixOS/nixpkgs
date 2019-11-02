{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "avro";
  version = "1.9.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "16pvgdv5pqx4zgjj0a4v5fz4brfjcrfx72mcmyvb2xqqp7q6ph4z";
  };

  meta = with stdenv.lib; {
    description = "A serialization and RPC framework";
    homepage = https://pypi.python.org/pypi/avro/;
  };
}
