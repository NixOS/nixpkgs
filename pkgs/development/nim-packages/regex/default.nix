{ lib, buildNimPackage, fetchFromGitHub, unicodedb }:

buildNimPackage (finalAttrs: {
  pname = "regex";
  version = "0.20.2";
  src = fetchFromGitHub {
    owner = "nitely";
    repo = "nim-regex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VViDf0uD6bj9WOO827NRbLUt+PgBPEmz/A/DDRCrHpc=";
  };
  propagatedBuildInputs = [ unicodedb ];
  doCheck = false;
  meta = finalAttrs.src.meta // {
    description = "Pure Nim regex engine";
    homepage = "https://github.com/nitely/nim-regex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
