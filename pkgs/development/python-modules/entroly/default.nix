{
  lib,
  buildPythonPackage,
  entroly-core,
  fetchFromGitHub,
  git,
  hatchling,
  mcp,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "entroly";
  version = "1.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "juyterman1000";
    repo = "entroly";
    rev = "entroly-v${finalAttrs.version}";
    hash = "sha256-gueS31OPVhJ/b63MrD16pQL6txmyd88VHODtwvgPQGg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    entroly-core
    mcp
  ];

  nativeCheckInputs = [
    git
    pytestCheckHook
  ];

  pythonImportsCheck = [ "entroly" ];

  meta = {
    description = "Information-theoretic context optimization for AI coding agents";
    homepage = "https://github.com/juyterman1000/entroly";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.guelakais ];
    mainProgram = "entroly";
  };
})
