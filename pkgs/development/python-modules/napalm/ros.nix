{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  napalm,
  librouteros,
  pytestCheckHook,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "napalm-ros";
  version = "1.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "napalm-automation-community";
    repo = "napalm-ros";
    tag = finalAttrs.version;
    hash = "sha256-Fv11Blx44vZZ8NuhQQIFpDr+dH2gDJtQP7b0kAk3U/s=";
  };

  # Setuptools is wrong, upstream uses poetry
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["setuptools>=56.0.0", "wheel"]' 'requires = ["poetry-core"]' \
      --replace-fail 'build-backend = "setuptools.build_meta"' 'build-backend = "poetry.core.masonry.api"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    librouteros
    napalm
  ];

  pythonRelaxDeps = [
    "librouteros"
    "napalm"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError: Some methods vary.
    "test_method_signatures"
  ];

  pythonImportsCheck = [ "napalm_ros" ];

  meta = {
    description = "MikroTik RouterOS NAPALM driver";
    homepage = "https://github.com/napalm-automation-community/napalm-ros";
    changelog = "https://github.com/napalm-automation-community/napalm-ros/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
