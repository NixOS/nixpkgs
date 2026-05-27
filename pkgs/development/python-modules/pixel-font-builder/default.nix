{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  nix-update-script,
  uv-build,
  fonttools,
  brotli,
  bdffont,
  pcffont,
  pypng,
}:

buildPythonPackage rec {
  pname = "pixel-font-builder";
  version = "0.0.47";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "pixel-font-builder";
    tag = version;
    hash = "sha256-a25JKZy5XaBfpeFwH7YnSTY28hQF8dLa/AGEOXHN94I=";
  };

  build-system = [ uv-build ];

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
