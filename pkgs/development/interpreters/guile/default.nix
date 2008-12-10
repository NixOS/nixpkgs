{ fetchurl, stdenv, libtool, readline, gmp
, gawk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "guile-1.8.6";
  src = fetchurl {
    url = "mirror://gnu/guile/" + name + ".tar.gz";
    sha256 = "11hxk8hyibbvjlk3zyf8vnl0xm0kvhmymj643inpbzw02i4zk8k9";
  };

  patches = [ ./popen-zombie.patch ];

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [readline libtool gmp gawk];

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"
  '';

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
  };
}
