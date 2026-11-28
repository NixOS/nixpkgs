{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "arsc-writer";
  version = "0.1.0";

  pyproject = true;
  __structuredAttrs = true;

  # nixpkgs-update: no auto update
  # Only weblate uses this and we want to follow its version constraints
  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "arsc-writer";
    tag = finalAttrs.version;
    hash = "sha256-iVtuGi5/bYT18gBSEcR68nqft4RIwmP7yLD+WGJYvWs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.13,<0.13" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    lxml
  ];

  pythonRelaxDeps = [ "lxml" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "arsc_writer" ];

  meta = {
    description = "A pure-Python library for generating Android resource tables (ARSC) with support for strings, plurals, and styled text";
    homepage = "https://github.com/WeblateOrg/arsc-writer";
    changelog = "https://github.com/WeblateOrg/arsc-writer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };

})
