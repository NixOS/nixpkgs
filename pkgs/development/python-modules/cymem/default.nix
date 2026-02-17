{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cymem";
  version = "2.0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cymem";
    tag = "release-v${version}";
    hash = "sha256-n65tkACZi1G4qS/VQWB5ghopzCd5QHRyp9qit+yENIs=";
  };

  build-system = [
    setuptools
    cython
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # remove src module, so tests use the installed module instead
    mv ./cymem/tests ./tests
    rm -r ./cymem
  '';

  pythonImportsCheck = [ "cymem" ];

  meta = {
    description = "Cython memory pool for RAII-style memory management";
    homepage = "https://github.com/explosion/cymem";
    changelog = "https://github.com/explosion/cymem/releases/tag/release-${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
