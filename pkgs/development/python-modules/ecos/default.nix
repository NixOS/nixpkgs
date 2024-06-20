{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  oldest-supported-numpy,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ecos";
  version = "2.0.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "embotech";
    repo = "ecos-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-3NcZBZ7fnwiMelGssa74b5PgmXmNZhP4etNRpyrCkpo=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    oldest-supported-numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ecos" ];

  meta = with lib; {
    description = "Python interface for ECOS";
    homepage = "https://github.com/embotech/ecos-python";
    changelog = "https://github.com/embotech/ecos-python/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
