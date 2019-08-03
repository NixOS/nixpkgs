{ lib, fetchFromGitLab }:

let
  pname = "open-sans";
  version = "1.11";
in fetchFromGitLab rec {
  name = "${pname}-${version}";

  domain = "salsa.debian.org";
  owner = "fonts-team";
  repo = "fonts-open-sans";
  rev = "debian%2F1.11-1"; # URL-encoded form of "debian/1.11-1" tag
  postFetch = ''
    tar xf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';
  sha256 = "146ginwx18z624z582lrnhil8jvi9bjg6843265bgxxrfmf75vhp";

  meta = with lib; {
    description = "Open Sans fonts";
    longDescription = ''
      Open Sans is a humanist sans serif typeface designed by Steve Matteson,
      Type Director of Ascender Corp.
    '';
    homepage = https://www.opensans.com;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.worldofpeace ];
  };
}
