{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "calmsize";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stonesjtu";
    repo = "calmsize";
    tag = version;
    hash = "sha256-D4UMzgYq++w6+Od0t9mDP4S+3Tc/ME5++NOlozXXALQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "calmsize" ];

  meta = {
    description = "Take a number of bytes and return a human-readable string";
    homepage = "https://github.com/Stonesjtu/calmsize";
    changelog = "https://github.com/Stonesjtu/calmsize/blob/${version}/CHANGES.md";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
