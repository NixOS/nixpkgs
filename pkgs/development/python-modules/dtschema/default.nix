{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  rfc3987,
  ruamel-yaml,
  setuptools-scm,
  libfdt,
  pytestCheckHook,
  dtc,
}:

buildPythonPackage (finalAttrs: {
  pname = "dtschema";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devicetree-org";
    repo = "dt-schema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DCkZDI0/W/4IkMzaa769vKJxlSMWoEsLIdlyChYd+Mk=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    jsonschema
    rfc3987
    ruamel-yaml
    libfdt
  ];

  pythonImportsCheck = [ "dtschema" ];

  nativeCheckInputs = [
    pytestCheckHook
    dtc
  ];

  enabledTestPaths = [ "test/test-dt-validate.py" ];

  meta = {
    description = "Tooling for devicetree validation using YAML and jsonschema";
    homepage = "https://github.com/devicetree-org/dt-schema/";
    changelog = "https://github.com/devicetree-org/dt-schema/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      bsd2 # or
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ sorki ];

    # Library not loaded: @rpath/libfdt.1.dylib
    broken = stdenv.hostPlatform.isDarwin;
  };
})
