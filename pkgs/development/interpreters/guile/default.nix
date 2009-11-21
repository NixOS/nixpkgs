{ fetchurl, stdenv, libtool, readline, gmp
, gawk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "guile-1.8.7";
  src = fetchurl {
    url = "mirror://gnu/guile/" + name + ".tar.gz";
    sha256 = "1czhcrn6l63xhsw3fjmv88djflqxbdpxjhgmwwvscm8rv4wn7vmz";
  };

  buildNativeInputs = [ makeWrapper ];
  propagatedBuildInputs = [ libtool gmp ];
  propagatedBuildNativeInputs = [readline gawk];

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"
  '';

  NIX_DEBUG=1;

  preBuild = ''
    sed -e '/lt_dlinit/a  lt_dladdsearchdir("'$out/lib'");' -i libguile/dynl.c
  '';

  doCheck = true;

  setupHook = ./setup-hook.sh;

  meta = {
    description = "GNU Guile, an embeddable Scheme interpreter";
    longDescription = ''
      GNU Guile is an interpreter for the Scheme programming language,
      packaged as a library that can be embedded into programs to make
      them extensible.  It supports many SRFIs.
    '';

    homepage = http://www.gnu.org/software/guile/;
    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
