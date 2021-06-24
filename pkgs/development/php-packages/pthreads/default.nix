{ buildPecl, lib, fetchFromGitHub, php, pcre' }:
let
  pname = "pthreads";

  isPhp73 = lib.versionAtLeast php.version "7.3";
  isPhp74 = lib.versionAtLeast php.version "7.4";

  version = if isPhp73 then "3.2.0-dev" else "3.2.0";

  src = fetchFromGitHub ({
    owner = "krakjoe";
    repo = "pthreads";
  } // (if (isPhp73) then {
    rev = "4d1c2483ceb459ea4284db4eb06646d5715e7154";
    sha256 = "07kdxypy0bgggrfav2h1ccbv67lllbvpa3s3zsaqci0gq4fyi830";
  } else {
    rev = "v3.2.0";
    sha256 = "17hypm75d4w7lvz96jb7s0s87018yzmmap0l125d5fd7abnhzfvv";
  }));
in
buildPecl {
  inherit pname version src;

  buildInputs = [ pcre'.dev ];

  meta.broken = isPhp74;
  meta.maintainers = lib.teams.php.members;
}
