{ lib, fetchzip }:

let
  version = "0.114";

in fetchzip rec {
  name = "Amiri-${version}";

  url = "https://github.com/alif-type/amiri/releases/download/${version}/${name}.zip";

  sha256 = "sha256-6FA46j1shP0R8iEi/Xop2kXS0OKW1jaGUEOthT3Z5b4=";

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

