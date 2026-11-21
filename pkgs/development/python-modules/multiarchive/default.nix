{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # tests
  pytestCheckHook,
  rarfile,
}:

buildPythonPackage (finalAttrs: {
  pname = "multiarchive";
  version = "0.1.4.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NSPC911";
    repo = "multiarchive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7YOcB0z3ZzYATPAbBZIHOvLDrc/Dl2K9TBQtaG9+58o=";
  };

  #TODO: target uv_build>=0.12.0 when https://github.com/NixOS/nixpkgs/pull/554025
  # ([python-updates] major updates 2026-08-18) reaches master
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.12.0,<0.13.0' 'uv_build'
  '';

  build-system = [
    uv-build
  ];

  nativeCheckInputs = [
    pytestCheckHook
    rarfile
  ];

  pythonImportsCheck = [ "multiarchive" ];

  meta = {
    changelog = "https://github.com/NSPC911/multiarchive/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/NSPC911/multiarchive";
    description = "Unified interface for reading multiple archive formats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kangazero ];
  };
})
