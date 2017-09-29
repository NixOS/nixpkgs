{ stdenv, buildPythonPackage, fetchPypi,
  six, cligj, munch, click-plugins, enum34, pytest, nose,
  gdal
}:

buildPythonPackage rec {
  pname = "Fiona";
  version = "1.7.9";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fmdgpfnifaqfqwkfiwkpk19wmpi9avmh8a7jqylqi578jvp3fwi";
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
