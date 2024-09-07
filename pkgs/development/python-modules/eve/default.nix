{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flask,
  events,
  pymongo,
  simplejson,
  cerberus,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eve";
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "Eve";
    hash = "sha256-NobIzu+7+NI7M4NRQKjrhye3v6YGMeGnbDRB39b3Dy8=";
  };

  disabled = pythonOlder "3.7";

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
      --replace "events>=0.3,<0.4" "events>=0.3"
  '';

  pythonImportsCheck = [ "eve" ];

  # tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    homepage = "https://python-eve.org/";
    description = "Open source Python REST API framework designed for human beings";
    changelog = "https://github.com/pyeve/eve/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
