{
  lib,
  buildPythonPackage,
  flet-client-flutter,

  # build-system
  poetry-core,

  flet,
  fastapi,
  uvicorn,
  python,
}:

buildPythonPackage rec {
  pname = "flet-web";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  sourceRoot = "${src.name}/sdk/python/packages/flet-web";

  build-system = [ poetry-core ];

  dependencies = [
    flet
    fastapi
    uvicorn
  ];

  pythonImportsCheck = [ "flet_web" ];

  web = flet-client-flutter.override {
    fletTarget = "web";
  };

  postInstall = ''
    ln -s $web $out/${python.sitePackages}/flet_web/web
  '';

  meta = {
    description = "Flet web client in Flutter";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
      lucasew
    ];
  };
}
