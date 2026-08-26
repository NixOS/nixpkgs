{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiovlc";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiovlc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PA8meWB0LOZX503+GVep03GiUh65MsLI+C6Fe9Iz6nc=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    cli = [ typer ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "aiovlc" ];

  meta = {
    description = "Python module to control VLC";
    homepage = "https://github.com/MartinHjelmare/aiovlc";
    changelog = "https://github.com/MartinHjelmare/aiovlc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
