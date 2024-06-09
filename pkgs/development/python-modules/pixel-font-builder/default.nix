{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  nix-update-script,
  hatch-vcs,
  hatchling,
  bdffont,
  brotli,
  fonttools,
  pypng,
  pcffont,
  pythonRelaxDepsHook,
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

  pythonRelaxDeps = [ "fonttools" ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pypng
  ];

  dependencies = [
    bdffont
    brotli
    fonttools
    pcffont
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/pixel-font-builder";
    description = "A library that helps create pixel style fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}
