{ lib, fetchzip }:

let
  version = "0.112";

in fetchzip rec {
  name = "Amiri-${version}";

  url = "https://github.com/alif-type/amiri/releases/download/${version}/${name}.zip";

  sha256 = "13j8kglgca296czxjz1xvrbz6yx05s2xassiliyszndbkrhn6bkl";

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

