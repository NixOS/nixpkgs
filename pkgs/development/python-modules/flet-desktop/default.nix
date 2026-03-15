{
  lib,
  buildPythonPackage,
  flet-client-flutter,

  # build-system
  poetry-core,

  flet,
}:

buildPythonPackage rec {
  pname = "flet-desktop";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  sourceRoot = "${src.name}/sdk/python/packages/flet-desktop";

  build-system = [ poetry-core ];

  dependencies = [ flet ];

  _flet_setup_view = ''
    if 'FLET_VIEW_PATH' not in os.environ:
      os.environ['FLET_VIEW_PATH'] = '${flet-client-flutter}/bin'
  '';
  postPatch = ''
    echo "$_flet_setup_view" >> src/flet_desktop/__init__.py
  '';

  pythonImportsCheck = [ "flet_desktop" ];

  meta = {
    description = "Compiled Flutter Flet desktop client";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
      lucasew
    ];
  };
}
