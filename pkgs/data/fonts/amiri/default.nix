{ lib, fetchzip }:

let
  version = "0.113";

in fetchzip rec {
  name = "Amiri-${version}";

  url = "https://github.com/alif-type/amiri/releases/download/${version}/${name}.zip";

  sha256 = "0v5xm4spyww8wy6j9kpb01ixrakw7wp6jng4xnh220iy6yqcxm7v";

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

