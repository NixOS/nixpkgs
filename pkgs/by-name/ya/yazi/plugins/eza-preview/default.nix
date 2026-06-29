{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "eza-preview.yazi";
  version = "0-unstable-2025-05-22";

  installPhase = ''
    runHook preInstall

    cp -r . $out
    mv $out/init.lua $out/main.lua
    rm $out/*.png

    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "sharklasers996";
    repo = "eza-preview.yazi";
    rev = "7ca4c2558e17bef98cacf568f10ec065a1e5fb9b";
    hash = "sha256-ncOOCj53wXPZvaPSoJ5LjaWSzw1omHadKDrXdIb7G5U=";
  };

  meta = {
    description = "yazi plugin to preview directories using eza, list and tree modes";
    homepage = "https://github.com/sharklasers996/eza-preview.yazi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.felipe-9 ];
  };
}
