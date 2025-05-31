{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  unittestCheckHook,
  zhon,
}:

buildPythonPackage rec {
  pname = "hanzidentifier";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsroten";
    repo = "hanzidentifier";
    tag = "v${version}";
    hash = "sha256-TVS21zy5UR+tGgVRB6eUguy2PGgruxbc+QR0DYUWl4w=";
  };

  build-system = [ hatchling ];

  dependencies = [ zhon ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "hanzidentifier" ];

  meta = {
    description = "A Python module that identifies Chinese text as being Simplified or Traditional";
    homepage = "https://github.com/tsroten/hanzidentifier";
    changelog = "https://github.com/tsroten/hanzidentifier/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
}
