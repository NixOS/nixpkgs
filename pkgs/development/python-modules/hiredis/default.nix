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
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis-py";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-TXhl9ny6hdd4n/hHfTAL0ewGcnjZ1vvNwovklSgzkKk=";
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
    maintainers = with lib.maintainers; [ hythera ];
  };
})
