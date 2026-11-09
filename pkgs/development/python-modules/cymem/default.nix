{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cymem";
  version = "2.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cymem";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-lnk7r51HoY3Rw9o0A6pO6H0R1lqxQIC2dTJcCkiJrVM=";
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
    changelog = "https://github.com/explosion/cymem/releases/tag/release-${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
