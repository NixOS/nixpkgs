{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "gillius-2013.11.03";

  src = fetchurl {
    url = "http://mirrors.ctan.org/install/fonts/gillius.tds.zip";
    sha256 = "d031817f2ff973c0ceec49de2faafdf25e5b226c617139c0a2d92992874d2ee9";
  };

  buildInputs = [unzip];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/texmf-dist/fonts/opentype
    mkdir -p $out/share/fonts/opentype

    cp -r ./* $out/texmf-dist/
    cp -r fonts/{opentype,type1} $out/share/fonts/

    ln -s $out/texmf* $out/share/
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.1001fonts.com/gillius-adf-font.html";
    license = licenses.gpl2Plus;
    description = "Gillius font";
    longDescription = ''
      Gillius is a font that resembles that humanist sans-serif Gill Sans,
      designed by Eric Gill in 1926.
    '';
    maintainers = [ maintainers.jgertm ];
    platforms = platforms.all;
  };
}
