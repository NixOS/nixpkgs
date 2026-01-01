{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.1.4";
  pname = "forbiddenfruit";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clarete";
    repo = "forbiddenfruit";
    tag = version;
    hash = "sha256-yHIZsVn2UVmWeBNIzWDE6AOwAXZilPqXo+bVtXqGkJk=";
  };

  build-system = [ setuptools ];

  env.FFRUIT_EXTENSION = "true";

  pythonImportsCheck = [ "forbiddenfruit" ];

  doCheck = false; # uses nose

<<<<<<< HEAD
  meta = {
    description = "Patch python built-in objects";
    homepage = "https://github.com/clarete/forbiddenfruit";
    changelog = "https://github.com/clarete/forbiddenfruit/releases/tag/${version}";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Patch python built-in objects";
    homepage = "https://github.com/clarete/forbiddenfruit";
    changelog = "https://github.com/clarete/forbiddenfruit/releases/tag/${version}";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mit
      gpl3Plus
    ];
    maintainers = [ ];
  };
}
