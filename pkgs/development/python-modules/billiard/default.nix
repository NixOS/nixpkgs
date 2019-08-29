{ stdenv, buildPythonPackage, fetchPypi, isPyPy, pytest, case, psutil }:

buildPythonPackage rec {
  pname = "billiard";
  version = "3.6.0.0";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "756bf323f250db8bf88462cd042c992ba60d8f5e07fc5636c24ba7d6f4261d84";
  };

  checkInputs = [ pytest case psutil ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/billiard;
    description = "Python multiprocessing fork with improvements and bugfixes";
    license = licenses.bsd3;
  };
}
