{
  lib,
  buildPythonPackage,
  flet-client-flutter,
  pyprojectVersionPatchHook,

  # build-system
  setuptools,

  flet,
  fastapi,
  uvicorn,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "flet-web";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/sdk/python/packages/flet-web";

  # pyproject.toml is version = "0.1.0"; hook rewrites it to match the derivation.
  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    flet
    fastapi
    uvicorn
  ]
  ++ uvicorn.optional-dependencies.standard;

  pythonImportsCheck = [ "flet_web" ];

  web = flet-client-flutter.override {
    fletTarget = "web";
  };

  postInstall = ''
    ln -s ${finalAttrs.web} $out/${python.sitePackages}/flet_web/web
  '';

  meta = {
    description = "Flet web client in Flutter";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
    ];
  };
})
