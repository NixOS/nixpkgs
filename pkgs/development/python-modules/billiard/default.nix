{ stdenv, buildPythonPackage, fetchPypi, isPyPy, pytest, case }:

buildPythonPackage rec {
  pname = "billiard";
  version = "3.5.0.2";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1anw68rkja1dbgvndxz5mq6f89hmxwaha0fjcdnsl5j1wj7imc1y";
  };

  buildInputs = [ pytest case ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/billiard;
    description = "Python multiprocessing fork with improvements and bugfixes";
    license = licenses.bsd3;
  };
}
