{
<<<<<<< HEAD
  lib,
  buildPythonPackage,
=======
  buildPythonPackage,
  fetchPypi,
  lib,
  flit-core,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  click,
  colorama,
  deprecation-alias,
  domdf-python-tools,
<<<<<<< HEAD
  fetchPypi,
  flit-core,
  mistletoe,
  psutil,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "consolekit";
  version = "1.11.0";
=======
  mistletoe,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "consolekit";
  version = "1.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-PZGrN5GJVtDruZkW3bJJpOfTi1nT3lN6XoBaaMLJE8E=";
=======
    hash = "sha256-gePFFOq6jQF0QA0gls1+cjdNMRutZfM2Og6/FpP0w3Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ flit-core ];

  dependencies = [
    click
    colorama
    deprecation-alias
    domdf-python-tools
    mistletoe
    typing-extensions
  ];

<<<<<<< HEAD
  optional-dependencies = {
    terminals = [ psutil ];
  };

  pythonImportsCheck = [ "consolekit" ];

  meta = {
    description = "Additional utilities for click";
    homepage = "https://github.com/domdfcoding/consolekit";
    changelog = "https://github.com/domdfcoding/consolekit/releases/tag/v${version}";
=======
  meta = {
    description = "Additional utilities for click";
    homepage = "https://github.com/domdfcoding/consolekit";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
