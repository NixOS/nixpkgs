{ buildPythonPackage
, fetchPypi
, dateutil
, jmespath
, docutils
, ordereddict
, simplejson
, mock
, nose
}:

buildPythonPackage rec {
  pname = "botocore";
  version = "1.10.84";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3e4b5a2c903ea30d19d41ea2f65d0e51dce54f4f4c4dfd6ecd7b04f240844a8";
  };

  propagatedBuildInputs = [
    dateutil
    jmespath
    docutils
    ordereddict
    simplejson
  ];

  checkInputs = [ mock nose ];

  checkPhase = ''
    nosetests -v
  '';

  # Network access
  doCheck = false;

  meta = {
    homepage = https://github.com/boto/botocore;
    license = "bsd";
    description = "A low-level interface to a growing number of Amazon Web Services";
  };
}
