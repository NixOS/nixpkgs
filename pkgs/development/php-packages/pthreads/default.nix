{ buildPecl, lib, fetchFromGitHub, php, pcre2 }:

buildPecl {
  pname = "pthreads";
  version = "3.2.0-dev";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "pthreads";
    rev = "4d1c2483ceb459ea4284db4eb06646d5715e7154";
    sha256 = "07kdxypy0bgggrfav2h1ccbv67lllbvpa3s3zsaqci0gq4fyi830";
  };

  buildInputs = [ pcre2.dev ];

  meta.broken = lib.versionAtLeast php.version "7.4";
  meta.maintainers = lib.teams.php.members;
}
