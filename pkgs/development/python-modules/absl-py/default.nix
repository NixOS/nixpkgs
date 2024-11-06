{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eCB5DvuzFnOc3otOGTVyQ/w2CKFSAkKIUT3ZaNfZWf8=";
  };

  build-system = [ setuptools ];

  # checks use bazel; should be revisited
  doCheck = false;

  pythonImportsCheck = [ "absl" ];

  meta = {
    description = "Abseil Python Common Libraries";
    homepage = "https://github.com/abseil/abseil-py";
    changelog = "https://github.com/abseil/abseil-py/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
