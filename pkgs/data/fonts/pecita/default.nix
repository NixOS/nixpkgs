{ stdenv, fetchurl }:

let

  version = "5.4";

in

fetchurl rec {
  name = "pecita-${version}";

  url = "http://pecita.eu/b/Pecita.otf";

  downloadToTemp = true;

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    cp -v $downloadedFile $out/share/fonts/opentype/Pecita.otf
  '';

  recursiveHash = true;
  sha256 = "0pwm20f38lcbfkdqkpa2ydpc9kvmdg0ifc4h2dmipsnwbcb5rfwm";

  meta = with stdenv.lib; {
    homepage = http://pecita.eu/police-en.php;
    description = "Handwritten font with connected glyphs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
