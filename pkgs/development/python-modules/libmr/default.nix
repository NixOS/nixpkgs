{ stdenv, buildPythonPackage, fetchPypi, numpy, cython }:

buildPythonPackage rec {
  pname = "libmr";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "43ccd86693b725fa3abe648c8cdcef17ba5fa46b5528168829e5f9b968dfeb70";
  };

  propagatedBuildInputs = [ numpy cython ];

  # No tests in the pypi tarball
  doCheck = false;

  meta = with stdenv.lib; {
    description = "libMR provides core MetaRecognition and Weibull fitting functionality";
    homepage = https://github.com/Vastlab/libMR;
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}

