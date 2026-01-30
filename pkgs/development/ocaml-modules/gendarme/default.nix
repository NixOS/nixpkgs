{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage (finalAttrs: {
  pname = "gendarme";
  version = "0.4";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitHub {
    owner = "bensmrs";
    repo = "gendarme";
    tag = finalAttrs.version;
    hash = "sha256-yiHBAhnWYntv+5fKG7Sa1RqsnvWIsW0YDqp+uAzpg/s=";
  };

  meta = {
    description = "Marshalling library for OCaml";
    homepage = "https://github.com/bensmrs/gendarme";
    changelog = "https://github.com/bensmrs/gendarme/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = with lib.teams; [ ngi ];
  };
})
