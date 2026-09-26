{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mock,
  pytestCheckHook,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "configobj";
  version = "5.0.9";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DiffSK";
    repo = "configobj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-duPCGBaHCXp4A6ZHLnyL1SZtR7K4FJ4hs5wCE1V9WB4=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ mock ];

  pythonImportsCheck = [ "configobj" ];

  meta = {
    description = "Config file reading, writing and validation";
    homepage = "https://github.com/DiffSK/configobj";
    changelog = "https://github.com/DiffSK/configobj/blob/v${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
