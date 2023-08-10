{
  stdenv,
  pkgs,
  fetchFromGitea,
  lcrq,
  lib,
  libsodium,
  ...
}:
stdenv.mkDerivation rec {
  name = "librecast";
  version = "0.7-RC3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librecast";
    repo = "librecast";
    rev = "v${version}";
    sha256 = "sha256-AD3MpWg8Lp+VkizwYTuuS2YWM8e0xaMEavVIvwhSZRo=";
  };
  buildInputs = [ lcrq libsodium ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://librecast.net/librecast.html";
    changelog = "https://codeberg.org/librecast/librecast/src/tag/v${version}/CHANGELOG.md";
    description = "IPv6 multicast library";
    license = [ licenses.gpl2 licenses.gpl3 ];
    maintainers = with maintainers; [ albertchae aynish jleightcap ];
    platforms = lib.platforms.unix;
  };
}
