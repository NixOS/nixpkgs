{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lyngdorf";
  version = "1.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fishloa";
    repo = "lyngdorf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KasnlVp9Hx4B3NccLL1qaViLJRLKFY41yXu2bz1/8hA=";
  };

  build-system = [ poetry-core ];

  dependencies = [ attrs ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lyngdorf" ];

  meta = {
    description = "Library to control a Lyngdorf A/V processor";
    homepage = "https://github.com/fishloa/lyngdorf";
    changelog = "https://github.com/fishloa/lyngdorf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
