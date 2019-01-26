{ stdenv, buildPythonPackage, fetchPypi,
  six, cligj, munch, click-plugins, enum34, pytest, nose,
  gdal
}:

buildPythonPackage rec {
  pname = "Fiona";
  version = "1.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c6419b7ac29136708029f6a44b4ccd458735a4d241016c7b1bab41685c08d8f";
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
