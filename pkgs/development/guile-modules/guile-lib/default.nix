{stdenv, fetchurl, guile, texinfo}:

assert stdenv ? gcc && stdenv.gcc ? gcc && stdenv.gcc.gcc != null;

stdenv.mkDerivation rec {
  name = "guile-lib-0.2.2";

  src = fetchurl {
    url = "mirror://savannah/guile-lib/${name}.tar.gz";
    sha256 = "1f9n2b5b5r75lzjinyk6zp6g20g60msa0jpfrk5hhg4j8cy0ih4b";
  };

  buildInputs = [guile texinfo];

  doCheck = true;

  preCheck =
    # Make `libgcc_s.so' visible for `pthread_cancel'.
    '' export LD_LIBRARY_PATH="$(dirname $(echo ${stdenv.gcc.gcc}/lib*/libgcc_s.so)):$LD_LIBRARY_PATH"
    '';

  meta = {
    description = "Guile-Library, a collection of useful Guile Scheme modules";

    longDescription =
      '' guile-lib is intended as an accumulation place for pure-scheme Guile
         modules, allowing for people to cooperate integrating their generic
         Guile modules into a coherent library.  Think "a down-scaled,
         limited-scope CPAN for Guile".
      '';

    homepage = http://www.nongnu.org/guile-lib/;
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
