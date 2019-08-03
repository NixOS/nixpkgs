{ lib, fetchFromGitHub }:

fetchFromGitHub rec {
  name = "aurulent-sans-0.1";
  owner = "deepfire";
  repo = "hartke-aurulent-sans";
  rev = name;
  postFetch = ''
    mkdir -p $out/share/fonts
    tar xf $downloadedFile -C $out/share/fonts --strip=1
  '';
  sha256 = "1l60psfv9x0x9qx9vp1qnhmck7a7kks385m5ycrd3d91irz1j5li";

  meta = {
    description = "Aurulent Sans";
    longDescription = "Aurulent Sans is a humanist sans serif intended to be used as an interface font.";
    homepage = http://delubrum.org/;
    maintainers = with lib.maintainers; [ deepfire ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
