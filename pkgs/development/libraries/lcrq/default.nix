{
  stdenv,
  fetchFromGitea,
  lib
}:
stdenv.mkDerivation (finalAttrs: {
  name = "lcrq";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librecast";
    repo = "lcrq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-s8+uTF6GQ76wG1zoAxqCaVT1J5Rd7vxPKX4zbQx6ro4=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    changelog = "https://codeberg.org/librecast/lcrq/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "Librecast RaptorQ library.";
    homepage = "https://librecast.net/lcrq.html";
    license = [ lib.licenses.gpl2 lib.licenses.gpl3 ];
    maintainers = with lib.maintainers; [ albertchae aynish DMills27 jasonodoom jleightcap ];
    platforms = lib.platforms.gnu;
  };
})
