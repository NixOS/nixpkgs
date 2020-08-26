{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
}:

buildPythonPackage rec {
  pname = "random2";
  version = "1.0.1";
  doCheck = !isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "34ad30aac341039872401595df9ab2c9dc36d0b7c077db1cea9ade430ed1c007";
  };

  meta = with stdenv.lib; {
    homepage = "http://pypi.python.org/pypi/random2";
    description = "Python 3 compatible Python 2 `random` Module";
    license = licenses.psfl;
  };

}
