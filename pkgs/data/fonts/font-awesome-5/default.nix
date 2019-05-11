{ stdenv, fetchzip }:

let
  version = "5.8.2";
in fetchzip rec {
  name = "font-awesome-${version}";

  url = "https://github.com/FortAwesome/Font-Awesome/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "Font-Awesome-${version}/otfs/*.otf" -d $out/share/fonts/opentype
  '';

  sha256 = "1h0qhvkfyfs4579jvrk3gwc7dp4i9s46bkj406b493dvmxxhv986";

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
