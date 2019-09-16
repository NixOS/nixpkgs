{ lib, fetchzip }:

let
  version = "0.111";

in fetchzip rec {
  name = "Amiri-${version}";

  url = "https://github.com/alif-type/amiri/releases/download/${version}/${name}.zip";

  sha256 = "1w3a5na4mazspwy8j2hvpjha10sgd287kamm51p49jcr90cvwbdr";

  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype ${name}/*.ttf
    install -m444 -Dt $out/share/doc/${name}    ${name}/{*.txt,*.pdf}
  '';

  meta = with lib; {
    description = "A classical Arabic typeface in Naskh style";
    homepage = "https://www.amirifont.org/";
    license = licenses.ofl;
    maintainers = [ maintainers.vbgl ];
    platforms = platforms.all;
  };
}

