{ lib, fetchzip }:

let
  version = "0.900";

in fetchzip rec {
  name = "Amiri-${version}";

  url = "https://github.com/alif-type/amiri/releases/download/${version}/${name}.zip";

  sha256 = "sha256-FjuzWW9xVWDOxHBwYL4pmopQVc9KYHGHhye5tPdw68s=";

  postFetch = ''
    rm -rf $out/otf
    mkdir -p $out/share/fonts/truetype
    mv $out/*.ttf $out/share/fonts/truetype/
    mkdir -p $out/share/doc/${name}
    mv $out/{*.html,*.txt,*.md} $out/share/doc/${name}/
  '';

  meta = with lib; {
    description = "A classical Arabic typeface in Naskh style";
    homepage = "https://www.amirifont.org/";
    license = licenses.ofl;
    maintainers = [ maintainers.vbgl ];
    platforms = platforms.all;
  };
}

