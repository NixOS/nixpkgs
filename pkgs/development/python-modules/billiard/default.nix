{ stdenv, buildPythonPackage, fetchPypi, isPyPy, pytest, case, psutil }:

buildPythonPackage rec {
  pname = "billiard";
  version = "3.6.3.0";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0spssl3byzqsplra166d59jx8iqfxyzvcbx7vybkmwr5ck72a5yr";
  };

  checkInputs = [ pytest case psutil ];
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/celery/billiard";
    description = "Python multiprocessing fork with improvements and bugfixes";
    license = licenses.bsd3;
  };
}
