{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fixtures,
  less,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "autopage";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zaneb";
    repo = "autopage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oBZoGVvgUhrfcEUvmhIN7Wnsv+SvkC553LAhHGCVIBQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    fixtures
    less
    pytestCheckHook
  ]
  ++ fixtures.optional-dependencies.streams;

  pythonImportsCheck = [ "autopage" ];

  meta = {
    changelog = "https://github.com/zaneb/autopage/releases/tag/${finalAttrs.src.tag}";
    description = "Library to provide automatic paging for console output";
    homepage = "https://github.com/zaneb/autopage";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
