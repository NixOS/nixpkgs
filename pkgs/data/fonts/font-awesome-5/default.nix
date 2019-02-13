{ stdenv, fetchzip }:

let
  version = "5.6.3";
in fetchzip rec {
  name = "font-awesome-${version}";

  url = "https://github.com/FortAwesome/Font-Awesome/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "Font-Awesome-${version}/otfs/*.otf" -d $out/share/fonts/opentype
  '';

  sha256 = "0y3zar7hyx5pj8rpyk2kz3sx6zgrfif2ka2h4rg0b8h8qbja0al6";

  meta = with stdenv.lib; {
    description = "Font Awesome - OTF font";
    longDescription = ''
      Font Awesome gives you scalable vector icons that can instantly be customized.
      This package includes only the OTF font. For full CSS etc. see the project website.
    '';
    homepage = http://fortawesome.github.io/Font-Awesome/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ abaldeau ];
  };
}
