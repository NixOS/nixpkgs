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
  version = "1.20.27"; # N.B: if you change this, change boto3 and awscli to a matching version

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RHeAPwdkn02AsX0FSCDnoJuyyweS0N7MKBIQi8N1nEo=";
  };

  propagatedBuildInputs = [
    dateutil
    jmespath
    docutils
    ordereddict
    simplejson
    urllib3
  ];

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
