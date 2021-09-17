{ lib
, buildPythonPackage
, fetchPypi
, flask
, events
, pymongo
, simplejson
, cerberus
, setuptools
}:

buildPythonPackage rec {
  pname = "Eve";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5647ee7dd6e063b967276e49f564cd4f96decdd0a218482bdf86c404a2be1fbf";
  };

  propagatedBuildInputs = [
    cerberus
    events
    flask
    pymongo
    simplejson
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "events>=0.3,<0.4" "events>=0.3,<0.5"
  '';

  pythonImportsCheck = [ "eve" ];

  # tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    homepage = "https://python-eve.org/";
    description = "Open source Python REST API framework designed for human beings";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
