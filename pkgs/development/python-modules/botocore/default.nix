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
  name = "${pname}-${version}";
  pname = "botocore";
  version = "1.10.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19vlf2w05h9818hrhx8al4r9ngfhvhf2pxcwka9s7bc51qnhx4xh";
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
