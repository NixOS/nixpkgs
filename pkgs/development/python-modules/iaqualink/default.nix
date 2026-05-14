{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  httpx-retries,
  httpx,
  pytest-cov-stub,
  pytestCheckHook,
  pyyaml,
  respx,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "iaqualink";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flz";
    repo = "iaqualink-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bn4dcfTRkY+qc/c39ip+vZvlbqll7qZOl7phMgw9EjY=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    httpx
    httpx-retries
  ]
  ++ httpx.optional-dependencies.http2;

  optional-dependencies = {
    cli = [
      pyyaml
      typer
    ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    respx
    typer
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "iaqualink" ];

  meta = {
    description = "Python library for Jandy iAqualink";
    homepage = "https://github.com/flz/iaqualink-py";
    changelog = "https://github.com/flz/iaqualink-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
