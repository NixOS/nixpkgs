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
  version = "1.21.31"; # N.B: if you change this, change boto3 and awscli to a matching version

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WM0xXirglxrNs9fNqcnDa0HHMYH0GUOnRDgS1tPJrRg=";
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
