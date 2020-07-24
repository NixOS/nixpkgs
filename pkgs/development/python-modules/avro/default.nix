{ stdenv, buildPythonPackage, fetchPypi, isPy3k, pycodestyle, isort }:

buildPythonPackage rec {
  pname = "avro";
  version = "1.9.2";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4487f0e91d0d44142bd08b3c6da57073b720c3effb02eeb4e2e822804964c56b";
  };

  nativeBuildInputs = [ pycodestyle ];
  propagatedBuildInputs = [ isort ];

  meta = with stdenv.lib; {
    description = "A serialization and RPC framework";
    homepage = "https://pypi.python.org/pypi/avro/";
  };
}
