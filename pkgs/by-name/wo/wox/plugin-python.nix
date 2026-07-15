{
  python3Packages,
  wox,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "wox-plugin";
  inherit (wox)
    version
    src
    ;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/wox.plugin.python";

  build-system = with python3Packages; [
    hatchling
  ];

  meta = {
    inherit (wox.meta)
      description
      homepage
      license
      maintainers
      ;
  };
})
