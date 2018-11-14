{ stdenv,  fetchzip }:

let
  majorVersion = "0";
  minorVersion = "110";
  pname = "f5_6";
in

fetchzip rec {
  name = "${pname}-font-${majorVersion}.${minorVersion}";

  url = "http://dotcolon.net/DL/font/${pname}_${majorVersion}${minorVersion}.zip";
  sha256 = "04p6lccd26rhjbpq3ddxi5vkk3lk8lqbpnk8lakjzixp3fgdqpp4";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype/${pname}
    unzip -j $downloadedFile \*.otf  -d $out/share/fonts/opentype/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "A weighted decorative font.";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
  };
}
