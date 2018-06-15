{ stdenv, buildPythonPackage, fetchPypi,
  six, cligj, munch, click-plugins, enum34, pytest, nose,
  gdal
}:

buildPythonPackage rec {
  pname = "Fiona";
  version = "1.7.11.post2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5804c6f5f7e02cf1f95ca404c22653dd47d64e4496a0ba7af5a2d6b2051b872a";
  };

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
