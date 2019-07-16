{ lib, fetchzip }:

let
  majorVersion = "0";
  minorVersion = "10";
  pname = "penna";
in

fetchzip rec {
  name = "${pname}-font-${majorVersion}.${minorVersion}";

  url = "http://dotcolon.net/DL/font/${pname}.zip";
  sha256 = "0hk15yndm56l6rbdykpkry2flffx0567mgjcqcnsx1iyzwwla5km";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype/${pname}
    unzip -j $downloadedFile \*.otf  -d $out/share/fonts/opentype/${pname}
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "Geometric sans serif designed by Sora Sagano";
    longDescription = ''
     Penna is a geometric sans serif designed by Sora Sagano,
     with outsized counters in the uppercase and a lowercase
     with a small x-height.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.cc0;
  };
}
