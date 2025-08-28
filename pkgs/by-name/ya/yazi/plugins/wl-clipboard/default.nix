{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "wl-clipboard.yazi";
  version = "0-unstable-2025-05-22";

  installPhase = ''
    runHook preInstall

    cp -r . $out
    mv $out/init.lua $out/main.lua

    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "grappas";
    repo = "wl-clipboard.yazi";
    rev = "c4edc4f6adf088521f11d0acf2b70610c31924f0";
    hash = "sha256-jlZgN93HjfK+7H27Ifk7fs0jJaIdnOyY1wKxHz1wX2c=";
  };

  meta = {
    description = "Wayland implementation of a simple system clipboard for yazi file manager";
    homepage = "https://github.com/grappas/wl-clipboard.yazi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.felipe-9 ];
  };
}
