{ lib
, buildPythonPackage
, fetchPypi
, pyparsing
, numpy
, cython
, astropy
}:

buildPythonPackage rec {
  pname = "pyregion";
  version = "2.0";

  doCheck = false; # tests require pytest-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8ac5f764b53ec332f6bc43f6f2193ca13e8b7d5a3fb2e20ced6b2ea42a9d094";
  };

  propagatedBuildInputs = [
    pyparsing
    numpy
    cython
    astropy
  ];

  meta = with lib; {
    description = "Python parser for ds9 region files";
    homepage = https://github.com/astropy/pyregion;
    license = licenses.mit;
    maintainers = [ maintainers.smaret ];
  };
}
