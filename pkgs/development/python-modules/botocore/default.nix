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
  version = "1.8.33";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa29ea54f26b1193682332d3b4cdde7aa79b4eaccb23f70e88672509c24546f4";
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
