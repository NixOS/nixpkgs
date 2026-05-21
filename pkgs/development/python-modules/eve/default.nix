{
  lib,
  buildPythonPackage,
  cerberus,
  events,
  fetchFromGitHub,
  flask,
  pymongo,
  setuptools,
  simplejson,
}:

buildPythonPackage rec {
  pname = "eve";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyeve";
    repo = "eve";
    tag = "v${version}";
    hash = "sha256-y0QfxLDoTKNZuAKcPqrLjwkZ0mRseBVq7OyflwUd+Lk=";
  };

  pythonRelaxDeps = [ "events" ];

  build-system = [ setuptools ];

  dependencies = [
    cerberus
    events
    flask
    pymongo
    simplejson
  ];

  pythonImportsCheck = [ "eve" ];

  # Tests call a running mongodb instance
  doCheck = false;

  meta = {
    description = "Open source Python REST API framework designed for human beings";
    homepage = "https://python-eve.org/";
    changelog = "https://github.com/pyeve/eve/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
