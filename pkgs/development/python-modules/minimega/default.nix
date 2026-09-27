{
  buildPythonPackage,
  setuptools,
  minimega,
  lib,
}:
buildPythonPackage (finalAttrs: {
  inherit (minimega) pname version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/lib";

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    minimega
  ];

  preBuild = ''
    # Generate minimega bindings from custom program
    pyapigen -out minimega.py minimega
    cp ../README.md .
    cp ../VERSION .
  '';

  meta = {
    description = "Python bindings for minimega";
    homepage = "https://www.sandia.gov/minimega/";
    changelog = "https://github.com/sandia-minimega/minimega/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tbaldwin ];
  };
})
