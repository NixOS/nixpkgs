{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  yajl,
}:

buildPythonPackage (finalAttrs: {
  pname = "ijson";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ICRAR";
    repo = "ijson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jlap3pf17SM8AQOoYZCPuGOnNC/oRLBONBgA5NgJQYQ=";
  };

  build-system = [ setuptools ];

  buildInputs = [ yajl ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ijson" ];

  meta = {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    changelog = "https://github.com/ICRAR/ijson/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
