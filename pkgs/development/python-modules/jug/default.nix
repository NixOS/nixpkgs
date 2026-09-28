{
  lib,
  bottle,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  pyyaml,
  redis,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "jug";
  version = "2.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "jug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B+s+GsK3/YqmS2wGDMW+ClhMWubKjXc6f5TkGtpu8Rk=";
  };

  build-system = [ setuptools ];

  dependencies = [ bottle ]; # needed for webstatus sub-command

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    pyyaml
    redis
  ];

  pythonImportsCheck = [ "jug" ];

  meta = {
    description = "Task-Based Parallelization Framework";
    homepage = "https://jug.readthedocs.io/";
    downloadPage = "https://github.com/luispedro/jug";
    changelog = "https://github.com/luispedro/jug/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luispedro ];
  };
})
