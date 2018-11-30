{ stdenv,  fetchzip }:

let
  majorVersion = "0";
  minorVersion = "601";
  pname = "tenderness";
in

fetchzip rec {
  name = "${pname}-font-${majorVersion}.${minorVersion}";

  url = "http://dotcolon.net/DL/font/${pname}_${majorVersion}${minorVersion}.zip";
  sha256 = "0d88l5mzq0k63zsmb8d5w3hfqxy04vpv4j0j8nmj1xv6kikhhybh";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype/${pname}
    unzip -j $downloadedFile \*.otf  -d $out/share/fonts/opentype/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "Serif font designed by Sora Sagano with old-style figures";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
  };
}
