{
  lib,
  buildPythonPackage,
  cerberus,
  events,
  fetchFromGitHub,
  flask,
  pymongo,
  pythonOlder,
  setuptools,
  simplejson,
}:

buildPythonPackage rec {
  pname = "eve";
  version = "2.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyeve";
    repo = "eve";
    tag = "v${version}";
    hash = "sha256-SnypLhUGAw3e0KQ2CjP6NHTIypMJdN18zzzYAG14m7Y=";
  };

  pythonRelaxDeps = [ "events" ];

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    cerberus
    events
    flask
    pymongo
    simplejson
  ];

  pythonImportsCheck = [ "eve" ];

  # Tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source Python REST API framework designed for human beings";
    homepage = "https://python-eve.org/";
    changelog = "https://github.com/pyeve/eve/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
