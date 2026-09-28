{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  dateparser,
  orjson,
  pydantic,
  ua-parser,
}:

buildPythonPackage (finalAttrs: {
  pname = "lookyloo-models";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "lookyloo-models";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x0F9N6S6yHaOcppfZNRu0r1sgijtvqJEcBs0IAcoG6E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12,<0.13" "uv_build"
  '';

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ uv-build ];

  dependencies = [
    dateparser
    orjson
    pydantic
    ua-parser
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "lookyloo_models" ];

  meta = {
    description = "Set of models representing data passed around across the toolchain";
    homepage = "https://github.com/Lookyloo/lookyloo-models";
    changelog = "https://github.com/Lookyloo/lookyloo-models/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
