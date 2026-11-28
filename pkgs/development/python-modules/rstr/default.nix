{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "rstr";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gh5/MEsCke28EpVanLQJO/4cfB1I4Hl+dSuzvyokV0o=";
  };

  pyproject = true;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Python library to generate random strings";
    homepage = "https://github.com/leapfrogonline/rstr";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ danc86 ];
  };
}
