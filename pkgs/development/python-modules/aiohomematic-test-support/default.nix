{
  aiohomematic,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohomematic-test-support";
  inherit (aiohomematic) version src;
  pyproject = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
  '';

  sourceRoot = "${finalAttrs.src.name}/aiohomematic_test_support";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "aiohomematic_test_support" ];

  meta = {
    description = "Support-only package for AioHomematic (tests/dev)";
    homepage = "https://github.com/SukramJ/aiohomematic/tree/devel/aiohomematic_test_support";
    inherit (aiohomematic.meta) license maintainers;
  };
})
