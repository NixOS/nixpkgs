{
  lib,
  buildPythonPackage,
  cerberus,
  events,
  fetchFromGitHub,
  flask,
  pymongo,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  simplejson,
}:

buildPythonPackage rec {
  pname = "eve";
<<<<<<< HEAD
  version = "2.2.4";
  pyproject = true;

=======
  version = "2.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "pyeve";
    repo = "eve";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-58PYwDzeQMmCLdqJfxp153+/AYNzO4JNzs7llyr7GJc=";
=======
    hash = "sha256-SnypLhUGAw3e0KQ2CjP6NHTIypMJdN18zzzYAG14m7Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [ "events" ];

  build-system = [ setuptools ];

<<<<<<< HEAD
  dependencies = [
=======
  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    cerberus
    events
    flask
    pymongo
    simplejson
  ];

  pythonImportsCheck = [ "eve" ];

  # Tests call a running mongodb instance
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Open source Python REST API framework designed for human beings";
    homepage = "https://python-eve.org/";
    changelog = "https://github.com/pyeve/eve/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Open source Python REST API framework designed for human beings";
    homepage = "https://python-eve.org/";
    changelog = "https://github.com/pyeve/eve/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
