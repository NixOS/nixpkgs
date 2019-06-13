{ lib, fetchzip }:

let
  majorVersion = "0";
  minorVersion = "200";
  pname = "eunomia";
in

fetchzip rec {
  name = "${pname}-font-${majorVersion}.${minorVersion}";

  url = "http://dotcolon.net/DL/font/${pname}_${majorVersion}${minorVersion}.zip";
  sha256 = "0lpmczs1d4p9dy4s0dnvv7bl5cd0f6yzyasfrkxij5s86glps38b";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype/${pname}
    unzip -j $downloadedFile \*.otf  -d $out/share/fonts/opentype/${pname}
  '';

  meta = with lib; {
    homepage = http://dotcolon.net/font/eunomia/;
    description = "A futuristic decorative font.";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
  };
}
