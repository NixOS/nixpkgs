{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:

mkYaziPlugin {
  pname = "gitui.yazi";
  version = "0-unstable-2025-05-26";

  src = fetchFromGitHub {
    owner = "gclarkjr5";
    repo = "gitui.yazi";
    rev = "397e9cf9cff536a43e746d72e0e81fd5c3050d2d";
    hash = "sha256-Bo16/5XuSxRhN6URwTBxuw0FTMHLF3nV1UDBQQJFHMM=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out
    mv $out/init.lua $out/main.lua
    runHook postInstall
  '';

  meta = {
    description = "Plugin for Yazi to manage git repos with gitui";
    homepage = "https://github.com/gclarkjr5/gitui.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felipe-9 ];
  };
}
