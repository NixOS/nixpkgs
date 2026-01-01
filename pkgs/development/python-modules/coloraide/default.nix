{
<<<<<<< HEAD
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  typing-extensions,
}:
let
  version = "6.2";
in
buildPythonPackage {
  pname = "coloraide";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "coloraide";
    tag = version;
    hash = "sha256-WWqHYeFqdVAgBIiBgr5o8URI+ZyMIn7efnbTyelJgII=";
=======
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  typing-extensions,
}:
let
  pname = "coloraide";
  version = "5.1";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DfBmpjbb2EgZgfrEkCQNPtkGtANDx8AXErPfVC8rJ1A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [
    "coloraide"
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Library to aid in using colors";
    homepage = "https://github.com/facelessuser/coloraide";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
      lib.maintainers.djacu
=======
  meta = {
    description = "Color library for Python";
    homepage = "https://pypi.org/project/coloraide/";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
  };
}
