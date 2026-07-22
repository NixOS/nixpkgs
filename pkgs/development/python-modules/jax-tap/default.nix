{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  jax,

  # optional-dependencies
  pandas,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jax-tap";
  version = "0.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "arcueil";
    repo = "jax-tap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xMBiEuACoPFSIlhR+/k4dBCGxqDqN7jkioSmsBlpWYk=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    jax
  ];

  optional-dependencies = {
    pandas = [
      pandas
    ];
  };

  pythonImportsCheck = [ "jaxtap" ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
  ];

  meta = {
    description = "Make print-debugging great again";
    homepage = "https://github.com/arcueil/jax-tap";
    changelog = "https://github.com/arcueil/jax-tap/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
