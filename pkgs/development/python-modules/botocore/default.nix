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
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f70f7f5682a2e7593079ec813f774044ef464b0ebe680dab47930f40e230d6d5";
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
