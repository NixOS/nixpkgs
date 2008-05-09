{ fetchurl, stdenv, libtool, readline, gmp
, gawk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "guile-1.8.5";
  src = fetchurl {
    url = "mirror://gnu/guile/" + name + ".tar.gz";
    sha256 = "12b215bbqqkanapwh4dp3lnkg7k239dqiawfcdrb1zjz8hnkvxp2";
  };

  patches = [ ./popen-zombie.patch ];

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [readline libtool gmp gawk];

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"
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
