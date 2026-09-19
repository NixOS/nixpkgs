{
  lib,
  buildPythonPackage,
  flet-client-flutter,
  pyprojectVersionPatchHook,
  stdenv,

  # build-system
  setuptools,

  flet,
}:

buildPythonPackage (finalAttrs: {
  pname = "flet-desktop";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/sdk/python/packages/flet-desktop";

  _flet_setup_view = ''
    if 'FLET_VIEW_PATH' not in os.environ:
      os.environ['FLET_VIEW_PATH'] = '${flet-client-flutter}/bin'
  '';

  postPatch = ''
    echo "$_flet_setup_view" >> src/flet_desktop/__init__.py
  '';

  # pyproject.toml is version = "0.1.0"; hook rewrites it to match the derivation.
  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [ flet ];

  pythonImportsCheck = [ "flet_desktop" ];

  meta = {
    description = "Compiled Flutter Flet desktop client";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
    ];
    # Depends on the linux flet client, which vendors x86_64-only rive_native prebuilts.
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
  };
})
