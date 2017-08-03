{ stdenv, agda, fetchgit }:

agda.mkDerivation (self: rec {
  version = "0dca24a81d417db2ae8fc871eccb7776f7eae952";
  name = "agda-prelude-${version}";

  src = fetchgit {
    url = "https://github.com/UlfNorell/agda-prelude.git";
    rev = version;
    sha256 = "0gwfgvj96i1mx5v01bi46h567d1q1fbgvzv6z8zv91l2jhybwff5";
  };

  topSourceDirectories = [ "src" ];
  everythingFile = "src/Prelude.agda";

  meta = with stdenv.lib; {
    homepage = https://github.com/UlfNorell/agda-prelude;
    description = "Programming library for Agda";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ fuuzetsu mudri ];
  };
})
