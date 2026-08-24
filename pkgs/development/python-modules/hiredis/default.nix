{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hiredis";
  version = "3.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis-py";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-mdiOt+LkdcpjA30dEQffAQY7GmL69hp1E7s4Bu9uoFE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "hiredis" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -rf hiredis
  '';

  meta = {
    description = "Wraps protocol parsing code in hiredis, speeds up parsing of multi bulk replies";
    homepage = "https://github.com/redis/hiredis-py";
    changelog = "https://github.com/redis/hiredis-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.redis ];
  };
})
