{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  nix-update-script,
  hatchling,
  fonttools,
  brotli,
  bdffont,
  pcffont,
  pypng,
}:

buildPythonPackage rec {
  pname = "pixel-font-builder";
  version = "0.0.25";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "pixel_font_builder";
    inherit version;
    hash = "sha256-66mGZ7q64z+tTJSSveD7UCkTq7YXgsHTM25MqUSLfvM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    fonttools
    brotli
    bdffont
    pcffont
    pypng
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pixel_font_builder" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/pixel-font-builder";
    description = "Library that helps create pixel style fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
