{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hiredis";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis-py";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-9KIbXmEk4K2xdGM7SUV64mcSEPGQdDez9mAb/920gZs=";
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
    changelog = "https://github.com/redis/hiredis-py/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mmai ];
  };
}
