{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
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
  version = "1.20.97"; # N.B: if you change this, change boto3 and awscli to a matching version

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7e119cf3e0f4a36100f0e983583afa91a84fb27c479a1716820aee4f2e190ab";
  };

  propagatedBuildInputs = [
    python-dateutil
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

  pythonImportsCheck = [ "botocore" ];

  meta = with lib; {
    homepage = "https://github.com/boto/botocore";
    license = licenses.asl20;
    description = "A low-level interface to a growing number of Amazon Web Services";
  };
}
