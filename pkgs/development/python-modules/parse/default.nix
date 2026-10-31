{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytest-cov-stub,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "parse";
  version = "1.22.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "r1chardj0n3s";
    repo = "parse";
    tag = finalAttrs.version;
    hash = "sha256-fV05sCgaLl4m1wMkKRUQGhKws+cuUZtpNRICa5Pqbxo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    typing-extensions
  ];

  pythonImportsCheck = [ "parse" ];

  meta = {
    description = "parse() is the opposite of format()";
    homepage = "https://github.com/r1chardj0n3s/parse";
    changelog = "https://github.com/r1chardj0n3s/parse/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ alunduil ];
  };
})
