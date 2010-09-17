{stdenv, fetchurl, guile, texinfo}:

stdenv.mkDerivation rec {
  name = "guile-lib-0.1.9";

  src = fetchurl {
    url = "mirror://savannah/guile-lib/${name}.tar.gz";
    sha256 = "13sc2x9x0rmfgfa69wabyhajc70yiywih9ibszjmkhxcm2zx0gan";
  };

  buildInputs = [guile texinfo];

  doCheck = true;

  meta = {
    description = "Guile-Library, a collection of useful Guile Scheme modules";
    homepage = http://www.nongnu.org/guile-lib/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
