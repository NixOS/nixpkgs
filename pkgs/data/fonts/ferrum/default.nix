{ lib, fetchzip }:

let
  majorVersion = "0";
  minorVersion = "200";
  pname = "ferrum";
in

fetchzip rec {
  name = "${pname}-font-${majorVersion}.${minorVersion}";

  url = "http://dotcolon.net/DL/font/${pname}.zip";
  sha256 = "1w1b3ch7ik4264f05lxms01ls0aargvlx770a9szm682dfmizn8w";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype/${pname}
    unzip -j $downloadedFile \*.otf  -d $out/share/fonts/opentype/${pname}
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "A decorative font.";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.cc0;
  };
}
