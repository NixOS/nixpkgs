{ stdenv, agda, fetchgit }:

agda.mkDerivation (self: rec {
  version = "d598f35d88596c5a63766a7188a0c0144e467c8c";
  name = "agda-prelude-${version}";

  src = fetchgit {
    url = "https://github.com/UlfNorell/agda-prelude.git";
    rev = version;
    sha256 = "bdcffb675d0ad1bafa2b47f581b6a9b90347ae739b6218f89f365fda2cc4f8c8";
  };

  topSourceDirectories = [ "src" ];
  everythingFile = "src/Prelude.agda";

  meta = with stdenv.lib; {
    homepage = "https://github.com/UlfNorell/agda-prelude";
    description = "Programming library for Agda";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ fuuzetsu ];
  };
})
