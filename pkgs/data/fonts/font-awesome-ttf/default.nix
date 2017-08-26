{ stdenv, fetchzip }:

let
  version = "4.7.0";
in fetchzip rec {
  name = "font-awesome-${version}";

  url = "https://github.com/FortAwesome/Font-Awesome/archive/v${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile Font-Awesome-${version}/fonts/fontawesome-webfont.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "0w8y7gxbqiy444phg4jl89kc5hq3jffbkhab8p110qy9jx8s106s";

  meta = with stdenv.lib; {
    description = "Font Awesome - TTF font";
    longDescription = ''
      Font Awesome gives you scalable vector icons that can instantly be customized.
      This package includes only the TTF font. For full CSS etc. see the project website.
    '';
    homepage = http://fortawesome.github.io/Font-Awesome/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ abaldeau ];
  };
}
