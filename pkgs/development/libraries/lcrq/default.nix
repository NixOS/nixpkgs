{
  stdenv,
  fetchFromGitea,
  lib
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lcrq";
  version = "0.2.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librecast";
    repo = "lcrq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xhv1rU0CImd5vs0bMdF1eJZt2AToU/JhBsoCsCLdyyg=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    changelog = "https://codeberg.org/librecast/lcrq/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "Librecast RaptorQ library";
    homepage = "https://librecast.net/lcrq.html";
    license = [ lib.licenses.gpl2 lib.licenses.gpl3 ];
    maintainers = with lib.maintainers; [ albertchae aynish DMills27 jasonodoom jleightcap ];
    platforms = lib.platforms.unix;
  };
})
