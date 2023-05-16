<<<<<<< HEAD
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
=======
{ fetchFromGitHub }:

fetchFromGitHub {
  owner = "nitely";
  repo = "nim-regex";
  rev = "eeefb4f";
  sha256 = "13gn0qhnxz07474kv94br5qlac9j8pz2555fk83538fiq83vgbm5";
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
