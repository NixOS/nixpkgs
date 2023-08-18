{
  stdenv,
  fetchFromGitea,
  lcrq,
  lib,
  libsodium,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "librecast";
  version = "0.7-RC3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librecast";
    repo = "librecast";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AD3MpWg8Lp+VkizwYTuuS2YWM8e0xaMEavVIvwhSZRo=";
  };
  buildInputs = [ lcrq libsodium ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    changelog = "https://codeberg.org/librecast/librecast/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "IPv6 multicast library";
    homepage = "https://librecast.net/librecast.html";
    license = [ lib.licenses.gpl2 lib.licenses.gpl3 ];
    maintainers = with lib.maintainers; [ albertchae aynish DMills27 jasonodoom jleightcap ];
    platforms = lib.platforms.gnu;
  };
})
