{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "kdeconnect-send.yazi";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "Deepak22903";
    repo = "kdeconnect-send.yazi";
    rev = "06674d12779bd7243793bb29cf0a5f1273467d3d";
    hash = "sha256-pfvmjQw8m/0yUdCK+TW0mvZDWAfyx1skmPjvWSTvk00=";
  };

  meta = {
    description = "Send selected files to your smartphone or other devices using KDE Connect";
    homepage = "https://github.com/Deepak22903/kdeconnect-send.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
  };
}
