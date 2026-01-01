{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchPypi,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "nocasedict";
  version = "2.1.0";
  pyproject = true;

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "pywbem";
    repo = "nocasedict";
    tag = version;
    hash = "sha256-6n0id4WBdrD+rYX9tFuynA6bV1n1LjVy5dj/TgXNkPw=";
=======
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tWPVhRy7DgsQ+7YYm6h+BhLSLlpvOgBKRXOrWziqqn0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nocasedict" ];

<<<<<<< HEAD
  meta = {
    description = "Case-insensitive ordered dictionary for Python";
    homepage = "https://github.com/pywbem/nocasedict";
    changelog = "https://github.com/pywbem/nocasedict/blob/${src.tag}/docs/changes.rst";
    license = lib.licenses.lgpl21Plus;
=======
  meta = with lib; {
    description = "Case-insensitive ordered dictionary for Python";
    homepage = "https://github.com/pywbem/nocasedict";
    changelog = "https://github.com/pywbem/nocasedict/blob/${version}/docs/changes.rst";
    license = licenses.lgpl21Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
