{
  stdenv,
  fetchFromGitea,
  lib
}:
stdenv.mkDerivation (finalAttrs: {
  name = "lcrq";
  version = "0.1.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librecast";
    repo = "lcrq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-r4UiZ9oNDxF3rHMqg+1NLLjm6LPZtzgtZOs7pRe5SdQ=";
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
