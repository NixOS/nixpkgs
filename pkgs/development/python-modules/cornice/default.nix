{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pyramid,
  pytestCheckHook,
  pytest-cache,
  webtest,
  marshmallow,
  colander,
}:

buildPythonPackage rec {
  pname = "cornice";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cornices";
    repo = "cornice";
    rev = version;
    hash = "sha256-jAf8unDPpr/ZAWkb9LhOW4URjwcRnaYVUKmfnYBStTg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ pyramid ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cache
    webtest
    marshmallow
    colander
  ];
  pythonImportsCheck = [ "cornice" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/mozilla-services/cornice";
    description = "Build Web Services with Pyramid";
    license = lib.licenses.mpl20;
=======
  meta = with lib; {
    homepage = "https://github.com/mozilla-services/cornice";
    description = "Build Web Services with Pyramid";
    license = licenses.mpl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
