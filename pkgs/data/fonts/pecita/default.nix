{stdenv, fetchzip}:

let
  version = "5.4";
in fetchzip rec {
  name = "pecita-${version}";

  url = "http://archive.rycee.net/pecita/${name}.tar.xz";

  postFetch = ''
    tar xJvf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/opentype
    cp -v Pecita.otf $out/share/fonts/opentype/Pecita.otf
  '';

  sha256 = "0pwm20f38lcbfkdqkpa2ydpc9kvmdg0ifc4h2dmipsnwbcb5rfwm";

  meta = with stdenv.lib; {
    homepage = http://pecita.eu/police-en.php;
    description = "Handwritten font with connected glyphs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
