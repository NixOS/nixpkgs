{stdenv, fetchurl, guile, texinfo}:

stdenv.mkDerivation rec {
  name = "guile-lib-0.2.0";

  src = fetchurl {
    url = "mirror://savannah/guile-lib/${name}.tar.gz";
    sha256 = "14acyznc0xgjd33fb9ngil102nvbhx12bvxi4hd25pl66i2d6izc";
  };

  buildInputs = [guile texinfo];

  doCheck = true;

  preCheck =
    # Make `libgcc_s.so' visible for `pthread_cancel'.
    '' export LD_LIBRARY_PATH="$(dirname $(echo ${stdenv.gcc.gcc}/lib*/libgcc_s.so)):$LD_LIBRARY_PATH"
    '';

  meta = {
    description = "Guile-Library, a collection of useful Guile Scheme modules";
    homepage = http://www.nongnu.org/guile-lib/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
