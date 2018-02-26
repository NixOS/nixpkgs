{ stdenv, buildPythonPackage, fetchPypi
, sqlite, isPyPy }:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.9.2-r1";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "dab96fd164dde9e59f7f27228291498217fa0e74048e2c08c7059d7e39589270";
  };

  buildInputs = [ sqlite ];

  # python: double free or corruption (fasttop): 0x0000000002fd4660 ***
#   doCheck = false;

  meta = with stdenv.lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = http://code.google.com/p/apsw/;
  };
}
