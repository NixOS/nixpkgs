{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  dateparser,
  orjson,
  pydantic,
  pydantic-extra-types,
  ua-parser,
}:

buildPythonPackage (finalAttrs: {
  pname = "lookyloo-models";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "lookyloo-models";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JQJxGlwBMJpIHRbk5snxY0Y0WkE5suv/p7H7Z0qqK2s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.13,<0.14" "uv_build"
  '';

  pythonRelaxDeps = [
    "orjson"
    "pydantic"
  ];

  build-system = [ uv-build ];

  dependencies = [
    dateparser
    orjson
    pydantic
    pydantic-extra-types
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
