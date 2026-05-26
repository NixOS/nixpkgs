{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "wl-clipboard.yazi";
  version = "0-unstable-2026-04-07";

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "grappas";
    repo = "wl-clipboard.yazi";
    rev = "8cc55242dbbc0b60fde27ab0d17bf11d91a14e14";
    hash = "sha256-pIKxWhaVDUOUKvVL4hGXn5zT4K7AvDi/VM+zBCX+19c=";
  };

  meta = {
    description = "Wayland implementation of a simple system clipboard for yazi file manager";
    homepage = "https://github.com/grappas/wl-clipboard.yazi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.felipe-9 ];
  };
}
