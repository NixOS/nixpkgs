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
  version = "1.16.24"; # N.B: if you change this, change boto3 and awscli to a matching version

  src = fetchPypi {
    inherit pname version;
    sha256 = "17bc71415186efb86a25dd674f78064cdd85139485967d5a0741c7b83d62cf5b";
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
    substituteInPlace setup.py --replace ",<0.16" ""
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
