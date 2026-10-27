{
  lib,
  buildPythonPackage,
  flet-client-flutter,
  pyprojectVersionPatchHook,
  stdenv,

  # build-system
  setuptools,

  binaryornot,
  chardet,
  cookiecutter,
  flet,
  flet-desktop,
  flet-web,
  packaging,
  qrcode,
  watchdog,
}:

buildPythonPackage (finalAttrs: {
  pname = "flet-cli";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/sdk/python/packages/flet-cli";

  # pyproject.toml is version = "0.1.0"; hook rewrites it to match the derivation.
  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    binaryornot
    chardet
    cookiecutter
    flet
    flet-desktop
    flet-web
    packaging
    qrcode
    watchdog
  ];

  pythonRelaxDeps = [
    "binaryornot"
    "chardet"
    "qrcode"
    "watchdog"
  ];

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    "$PYTHONPATH"
  ];

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper ${flet}/bin/flet $out/bin/flet \
      --prefix PYTHONPATH : $PYTHONPATH
  '';

  pythonImportsCheck = [ "flet_cli" ];

  meta = {
    description = "Command-line interface tool for Flet, a framework for building interactive multi-platform applications using Python";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
    ];
    mainProgram = "flet";
    # Depends on the linux flet client, which vendors x86_64-only rive_native prebuilts.
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
  };
})
