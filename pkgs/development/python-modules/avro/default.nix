{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "avro";
  version = "1.9.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0af72fcql34v30cvjqm9nmz68rl35znn5qbd4k3b9ks02xzy3b2y";
  };

  meta = with stdenv.lib; {
    description = "A serialization and RPC framework";
    homepage = https://pypi.python.org/pypi/avro/;
  };
}
