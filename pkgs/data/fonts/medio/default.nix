{ stdenv,  fetchzip }:

let
  majorVersion = "0";
  minorVersion = "200";
  pname = "medio";
in

fetchzip rec {
  name = "${pname}-font-${majorVersion}.${minorVersion}";

  url = "http://dotcolon.net/DL/font/${pname}.zip";
  sha256 = "0gxcmhjlsh2pzsmj78vw4v935ax7hfk533ddlhfhfma52zyxyh7x";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype/${pname}
    unzip -j $downloadedFile \*.otf  -d $out/share/fonts/opentype/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "Serif font designed by Sora Sagano";
    longDescription = ''
      Medio is a serif font designed by Sora Sagano, based roughly
      on the proportions of the font Tenderness (from the same designer),
      but with hairline serifs in the style of a Didone.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.cc0;
  };
}
