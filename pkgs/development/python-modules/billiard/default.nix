{ stdenv, buildPythonPackage, fetchPypi, isPyPy, pytest, case }:

buildPythonPackage rec {
  pname = "billiard";
  version = "3.5.0.4";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed65448da5877b5558f19d2f7f11f8355ea76b3e63e1c0a6059f47cfae5f1c84";
  };

  buildInputs = [ pytest case ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/billiard;
    description = "Python multiprocessing fork with improvements and bugfixes";
    license = licenses.bsd3;
  };
}
