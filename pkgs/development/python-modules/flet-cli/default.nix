{
  lib,
  buildPythonPackage,
  flet-client-flutter,

  # build-system
  poetry-core,

  flet,
  flet-desktop,
  flet-web,
  qrcode,
  toml,
  watchdog,
}:

buildPythonPackage rec {
  pname = "flet-cli";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  sourceRoot = "${src.name}/sdk/python/packages/flet-cli";

  build-system = [ poetry-core ];

  dependencies = [
    flet
    flet-desktop
    flet-web
    qrcode
    toml
    watchdog
  ];

  pythonRelaxDeps = [
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
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
      lucasew
    ];
    mainProgram = "flet";
  };
}
