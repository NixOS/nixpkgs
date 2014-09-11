{ stdenv, agda, fetchgit }:

agda.mkDerivation (self: rec {
  version = "8a06162a8f0f7df308458db91d720cf8f7345d69";
  name = "Agda-Sheaves-${version}";
  src = fetchgit {
    url = "https://github.com/jonsterling/Agda-Sheaves.git";
    rev = version;
    sha256 = "39e0e4a1f05e359c099cf50a5ec7dd2db7b55f98dcc019f1e4667dca8b37f001";
  };

  everythingFile = "sheaves.agda";
  topSourceDirectories = [ "../$sourceRoot" ];
  sourceDirectories = [];

  meta = {
    homepage = "https://github.com/jonsterling/Agda-Sheaves";
    description = "Sheaves in Agda";
    license = "CC-BY-4.0";
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
})