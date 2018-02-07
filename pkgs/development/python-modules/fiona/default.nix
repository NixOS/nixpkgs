{ stdenv, buildPythonPackage, fetchPypi,
  six, cligj, munch, click-plugins, enum34, pytest, nose,
  gdal
}:

buildPythonPackage rec {
  pname = "Fiona";
  version = "1.7.11";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e9c68ea71e9d79fcfb68c9a101c0b133301e233c9bcca7b7c65f33cc7636ef5";
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
