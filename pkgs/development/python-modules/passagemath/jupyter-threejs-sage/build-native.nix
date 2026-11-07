{
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "jupyter-threejs-sage";
  version = "130";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    pname = "jupyter_threejs_sage";
    inherit version;
    hash = "sha256-4SwtmTPwejmv16+fR/uUjwjvN9Il7+/0Hl8ECcokndw=";
  };

  pythonImportsCheck = [ "jupyter_threejs_sage" ];
}
