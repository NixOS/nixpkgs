args: with args; 

stdenv.mkDerivation rec {
  name = "guile-1.8.4";
  src = fetchurl {
    url = "ftp://ftp.gnu.org/gnu/guile/" + name + ".tar.gz";
    sha256 = "1cz1d4n6vzw0lfsvplsiarwqk675f12j596dzfv0h5r9cljpc0ya";
  };

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [readline libtool gmp gawk];

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    description = ''GNU Guile is an interpreter for the Scheme
                    programming language, packaged as a library that
		    can be embedded into programs to make them extensible.'';
    homepage = http://www.gnu.org/software/guile/;
    license = "LGPL";
  };
}
