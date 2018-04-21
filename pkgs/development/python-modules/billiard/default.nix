{ stdenv, buildPythonPackage, fetchPypi, isPyPy, pytest, case }:

buildPythonPackage rec {
  pname = "billiard";
  version = "3.5.0.3";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d7b22bdc47aa52841120fcd22a74ae4fc8c13e9d3935643098184f5788c3ce6";
  };

  buildInputs = [ pytest case ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/billiard;
    description = "Python multiprocessing fork with improvements and bugfixes";
    license = licenses.bsd3;
  };
}
