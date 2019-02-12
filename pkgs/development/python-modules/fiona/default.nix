{ stdenv, buildPythonPackage, fetchPypi,
  six, cligj, munch, click-plugins, enum34, pytest, nose,
  gdal
}:

buildPythonPackage rec {
  pname = "Fiona";
  version = "1.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aec9ab2e3513c9503ec123b1a8573bee55fc6a66e2ac07088c3376bf6738a424";
  };

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11";

  buildInputs = [
    gdal
  ];

  propagatedBuildInputs = [
    six
    cligj
    munch
    click-plugins
    enum34
  ];

  checkInputs = [
    pytest
    nose
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "OGR's neat, nimble, no-nonsense API for Python";
    homepage = http://toblerity.org/fiona/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
