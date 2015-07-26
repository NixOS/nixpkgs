{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "pecita-${version}";
  version = "5.0";

  src = fetchurl {
    url = "http://pecita.eu/b/Pecita.otf";
    sha256 = "1smf1mqciwavf29lwgzjam3xb37bwxp6wf6na4c9xv6islidsrd9";
  };

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v ${src} $out/share/fonts/opentype/Pecita.otf
  '';

  meta = with stdenv.lib; {
    homepage = http://pecita.eu/police-en.php;
    description = "Handwritten font with connected glyphs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
