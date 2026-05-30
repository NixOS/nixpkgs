{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyahocorasick,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "multiregex";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quantco";
    repo = "multiregex";
    tag = version;
    hash = "sha256-S10FJwtFNK4CarE2YAcUM38hRYTDL0Vp4B8NqGvJs5M=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ pyahocorasick ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multiregex" ];

  meta = {
    description = "Quickly match many regexes against a string";
    homepage = "https://github.com/quantco/multiregex";
    changelog = "https://github.com/quantco/multiregex/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
