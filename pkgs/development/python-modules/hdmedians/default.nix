{ lib
, buildPythonPackage
, fetchPypi
, nose
, cython
, numpy
}:

buildPythonPackage rec {
  version = "0.14.2";
  format = "setuptools";
  pname = "hdmedians";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b47aecb16771e1ba0736557255d80ae0240b09156bff434321de559b359ac2d6";
  };

  # nose was specified in setup.py as a build dependency...
  buildInputs = [ cython nose ];
  propagatedBuildInputs = [ numpy ];

  # cannot resolve path for packages in tests
  doCheck = false;

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://github.com/daleroberts/hdmedians";
    description = "High-dimensional medians";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
