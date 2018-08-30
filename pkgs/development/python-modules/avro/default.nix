{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "avro";
  version = "1.8.2";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f9ee40830b70b5fb52a419711c9c4ad0336443a6fba7335060805f961b04b59";
  };

  meta = with stdenv.lib; {
    description = "A serialization and RPC framework";
    homepage = https://pypi.python.org/pypi/avro/;
  };
}
