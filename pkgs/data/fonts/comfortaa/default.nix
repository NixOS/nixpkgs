{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "comfortaa-${version}";
  version = "2.004";

  src = fetchurl {
    url = "http://openfontlibrary.org/assets/downloads/comfortaa/38318a69b56162733bf82bc0170b7521/comfortaa.zip";
    sha256 = "0js0kk5g6b7xrq92b68gz5ipbiv1havnbgnfqzvlw3k3nllwnl9z";
  };

  phases = ["unpackPhase" "installPhase"];

  buildInputs = [unzip];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    cp -v *.ttf $out/share/fonts/truetype/
    cp -v FONTLOG.txt $out/share/doc/${name}/
    cp -v donate.html $out/share/doc/${name}/
  '';

  meta = with stdenv.lib; {
    homepage = http://aajohan.deviantart.com/art/Comfortaa-font-105395949;
    description = "A clean and modern font suitable for headings and logos";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
