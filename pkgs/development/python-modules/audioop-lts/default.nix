{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "audioop-lts";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "AbstractUmbra";
    repo = "audioop";
    rev = "refs/tags/${version}";
    hash = "sha256-tx5/dcyEfHlYRohfYW/t0UkLiZ9LJHmI8g3sC3+DGAE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -rf audioop
  '';

  pythonImportsCheck = [
    "audioop"
  ];

  meta = {
    changelog = "https://github.com/AbstractUmbra/audioop/releases/tag/${version}";
    description = "An LTS port of Python's `audioop` module";
    homepage = "https://github.com/AbstractUmbra/audioop";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
