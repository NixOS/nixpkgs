{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  nix-update-script,
  hatchling,
}:

buildPythonPackage rec {
  pname = "bdffont";
  version = "0.0.35";
  pyproject = true;

  src = fetchPypi {
    pname = "bdffont";
    inherit version;
    hash = "sha256-b6iUpGiwBF35hQb7B4ONyjG+63nQqfoXamJPRb8VuWI=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bdffont" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/bdffont";
    description = "Library for manipulating Glyph Bitmap Distribution Format (BDF) Fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
