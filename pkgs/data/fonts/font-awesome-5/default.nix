{ lib, fetchFromGitHub }:

let
  version = "5.10.0";
in fetchFromGitHub rec {
  name = "font-awesome-${version}";

  owner = "FortAwesome";
  repo = "Font-Awesome";
  rev = version;

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/opentype otfs/*.otf
  '';

  sha256 = "11nga1drlpkrmw307ga6plbj5z1b70cnckr465z8z6vkbcd6jkv3";

  meta = with lib; {
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
