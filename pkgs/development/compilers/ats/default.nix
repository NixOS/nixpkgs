{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name    = "ats-${version}";
  version = "0.2.11";

  src = fetchurl {
    url = "mirror://sourceforge/ats-lang/ats-lang-anairiats-${version}.tgz";
    sha256 = "0rqykyx5whichx85jr4l4c9fdan0qsdd4kwd7a81k3l07zbd9fc6";
  };

  # this is necessary because atxt files usually include some .hats files
  patches = [ ./install-atsdoc-hats-files.patch ];
  buildInputs = [ gmp ];

  meta = {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = stdenv.lib.licenses.gpl3Plus;
    # TODO: it looks like ATS requires gcc specifically. Someone with more knowledge
    # will need to experiment.
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
