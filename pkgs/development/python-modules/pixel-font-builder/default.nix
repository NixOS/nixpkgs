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
  version = "0.0.55";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "pixel-font-builder";
    tag = version;
    hash = "sha256-WMwmhGspseqTkGUPrMNR16sZBB+n/lvthHX7JTtdlsQ=";
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
