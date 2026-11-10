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
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xKVk1N+0Ry2THRRcQ9HPGteMJFkhQud1W4hmF57qwBI=";
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
