{
  python3Packages,
  callPackage,
  wox,
  writableTmpDirAsHomeHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "wox-plugin-host-python";
  inherit (wox) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/wox.plugin.host.python";

  build-system = with python3Packages; [
    hatchling
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  buildInputs = with python3Packages; [
    loguru
    websockets
    finalAttrs.passthru.plugin-python
  ];

  dependencies = with python3Packages; [
    loguru
    websockets
    finalAttrs.passthru.plugin-python
  ];

  passthru = {
    plugin-python = callPackage ./plugin-python.nix { };
  };

  meta = {
    inherit (wox.meta)
      description
      homepage
      license
      maintainers
      ;
  };
})
