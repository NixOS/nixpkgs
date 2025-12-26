{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "wl-clipboard.yazi";
  version = "0-unstable-2025-08-30";

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "grappas";
    repo = "wl-clipboard.yazi";
    rev = "e9a38e47d07549968019702bdafdc4ed07151b7d";
    hash = "sha256-3PRQl4TvuOe5DwVi1gmtmfTOEVZWRayijIbnPgaR3L8=";
  };

  meta = {
    description = "Wayland implementation of a simple system clipboard for yazi file manager";
    homepage = "https://github.com/grappas/wl-clipboard.yazi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.felipe-9 ];
  };
}
