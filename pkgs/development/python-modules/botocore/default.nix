{ buildPythonPackage
, fetchPypi
, dateutil
, jmespath
, docutils
, ordereddict
, simplejson
, mock
, nose
, urllib3
}:

buildPythonPackage rec {
  pname = "botocore";
  version = "1.19.37"; # N.B: if you change this, change boto3 and awscli to a matching version

  src = fetchPypi {
    inherit pname version;
    sha256 = "14bl9sklilrz0fsch4zw1rx8zdq6h9va2786wxn36yax8n2i5gv7";
  };

  propagatedBuildInputs = [
    dateutil
    jmespath
    docutils
    ordereddict
    simplejson
    urllib3
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "docutils>=0.10,<0.16" "docutils>=0.10"
  '';

  checkInputs = [ mock nose ];

  checkPhase = ''
    nosetests -v
  '';

  # Network access
  doCheck = false;

  meta = {
    homepage = "https://github.com/boto/botocore";
    license = "bsd";
    description = "A low-level interface to a growing number of Amazon Web Services";
  };
}
