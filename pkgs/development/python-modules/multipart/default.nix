{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "multipart";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "defnull";
    repo = "multipart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Klo2HaIBo3xrCzQT2BxVpRCdaaKqCT1vtITMPABE6s0=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multipart" ];

  meta = {
    changelog = "https://github.com/defnull/multipart/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Parser for multipart/form-data";
    homepage = "https://github.com/defnull/multipart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
