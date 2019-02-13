{ stdenv, buildPythonPackage, fetchPypi, isPyPy, pytest, case }:

buildPythonPackage rec {
  pname = "billiard";
  version = "3.5.0.5";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "03msmapj3s5zgqk87d646mafz7a01h5bm2wijalgpi0s80ks5na2";
  };

  buildInputs = [ pytest case ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/billiard;
    description = "Python multiprocessing fork with improvements and bugfixes";
    license = licenses.bsd3;
  };
}
