{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "cymem";
  version = "2.0.11";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cymem";
    tag = "release-v${version}";
    hash = "sha256-4srwdQS06KeBAIaJm6XxmsHEZto0eiXBznrCHgT/BAc=";
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

  meta = with lib; {
    description = "Cython memory pool for RAII-style memory management";
    homepage = "https://github.com/explosion/cymem";
    changelog = "https://github.com/explosion/cymem/releases/tag/release-${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
