{ lib, fetchFromGitHub }:

let
  version = "5.8.2";
in fetchFromGitHub rec {
  name = "font-awesome-${version}";

  owner = "FortAwesome";
  repo = "Font-Awesome";
  rev = version;

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/opentype otfs/*.otf
  '';

  sha256 = "1h0qhvkfyfs4579jvrk3gwc7dp4i9s46bkj406b493dvmxxhv986";

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
