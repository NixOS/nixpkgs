{ stdenv, fetchurl, pure, pkgconfig, gsl }:

stdenv.mkDerivation {
  name = "pure-gsl-0.12";
  src = fetchurl {
    url = https://bitbucket.org/purelang/pure-lang/downloads/pure-gsl-0.12.tar.gz;
    sha256 = "06bdd873d5417d90ca35093056a060b77365123ed24c3ac583cd3922d4c78a75";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure gsl ];

  installPhase = ''
    mkdir -p $out/lib/pure/gsl
    install gsl.pure gsl$(pkg-config pure --variable DLL) $out/lib/pure
    install gsl/*.pure $out/lib/pure/gsl
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    description = "GNU Scientific Library interface for Pure";
    homepage = http://puredocs.bitbucket.org/pure-gsl.html;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}