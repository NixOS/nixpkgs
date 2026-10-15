{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,

  # build-system
  poetry-core,

  # dependencies
  multiprocess,
  pandas,
  pandas-stubs,
  pydantic,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pandantic";
  version = "1.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wesselhuising";
    repo = "pandantic";
    tag = finalAttrs.version;
    hash = "sha256-lqd4aQiBMbATFMdftKQeTlqQ3MGrxm2shb7qil+84iA=";
  };

  # Upstream forgot to bump the version in `pyproject.toml` for the 1.0.1 release
  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "pandas"
    "pandas-stubs"
  ];
  dependencies = [
    multiprocess
    pandas
    pandas-stubs
    pydantic
  ];

  pythonImportsCheck = [ "pandantic" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Module to enriche the Pydantic BaseModel class";
    homepage = "https://github.com/wesselhuising/pandantic";
    changelog = "https://github.com/wesselhuising/pandantic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
