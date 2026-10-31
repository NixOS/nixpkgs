{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "quickjs-ng";
  version = "0.13.0.1";
  pyproject = true;

  # Pypi version broken, missing upstream-quickjs files
  src = fetchFromGitHub {
    owner = "genotrance";
    repo = "quickjs-ng";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-PdPQRnU+v+wdzhSL3JBuuEW8ihEMnKZJYzPQs5cHyS8=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [
    stdenv
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "quickjs"
  ];

  meta = {
    description = "Thin Python wrapper of quickjs-ng";
    longDescription = ''
      Python wrapper around [quickjs-ng](https://github.com/quickjs-ng/quickjs),
      the actively maintained fork of the
      [QuickJS](https://bellard.org/quickjs/) JavaScript engine.

      Drop-in replacement for the archived
      [quickjs](https://github.com/PetterS/quickjs) package —
      `import quickjs` works unchanged.
    '';
    homepage = "https://github.com/genotrance/quickjs-ng";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luc65r ];
    platforms = lib.platforms.all;
  };
})
