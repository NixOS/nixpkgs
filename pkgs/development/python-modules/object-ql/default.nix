{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gramps,
  pyparsing,
  pytestCheckHook,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "object-ql";
  version = "0.1.3-unstable-2025-02-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dsblank";
    repo = "object-ql";
    rev = "81809e980faed7e8a5b5ba661b6b271d18408747";
    hash = "sha256-N1RucnR/QQvFf+RzSv45T5neU8QR2UN+nftZAy5LUkg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gramps
    pyparsing
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "object_ql" ];

  meta = {
    description = "Python query system for querying objects";
    homepage = "https://github.com/dsblank/object-ql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
