{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mcp,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "entroly";
  version = "0.19.13";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "juyterman1000";
    repo = "entroly";
    rev = "entroly-v${version}";

    hash = "sha256-Nh0BSTLDwVk373kn9JDW/tCpWXPU6n7GH93zCcshCI0=";
  };

  build-system = [ hatchling ];

  dependencies = [ mcp ];

  pythonImportsCheck = [ "entroly" ];

  meta = {
    description = "Information-theoretic context optimization for AI coding agents";
    homepage = "https://github.com/juyterman1000/entroly";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.guelakais ];
    mainProgram = "entroly";
  };
}
