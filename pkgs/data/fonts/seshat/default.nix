{ stdenv,  fetchzip }:

let
  majorVersion = "0";
  minorVersion = "100";
  pname = "seshat";
in

fetchzip rec {
  name = "${pname}-font-${majorVersion}.${minorVersion}";

  url = "http://dotcolon.net/DL/font/${pname}.zip";
  sha256 = "1zzgc2d0jrris92p3irmxjhdq8aj99alz0z7dlz25qf37lcilrir";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype/${pname}
    unzip -j $downloadedFile \*.otf  -d $out/share/fonts/opentype/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "Roman body font designed for main text by Sora Sagano";
    longDescription = ''
      Seshat is a Roman body font designed for the main text. By
      referring to the classical balance, we changed some lines by
      omitting part of the lines such as "A" and "n".

      Also, by attaching the strength of the thickness like Optima
      to the main drawing, it makes it more sharp design.

      It incorporates symbols and ligatures used in the European region.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.cc0;
  };
}
