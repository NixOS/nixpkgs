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
  version = "1.7.43";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wyyj7sk7dh9v7i1g5jc5maqdadvbs4khi7srz0095cywkjqpysc";
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
