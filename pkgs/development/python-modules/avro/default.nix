{ stdenv, buildPythonPackage, fetchPypi, isPy3k, pycodestyle, isort }:

buildPythonPackage rec {
  pname = "avro";
  version = "1.10.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbf9f89fd20b4cf3156f10ec9fbce83579ece3e0403546c305957f9dac0d2f03";
  };

  nativeBuildInputs = [ pycodestyle ];
  propagatedBuildInputs = [ isort ];

  meta = with stdenv.lib; {
    description = "A serialization and RPC framework";
    homepage = "https://pypi.python.org/pypi/avro/";
  };
}
