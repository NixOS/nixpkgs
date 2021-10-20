{ lib, fetchurl }:

let
  pname = "open-fonts";
  version = "0.7.0";
in
fetchurl {
  name = "${pname}-${version}";

  url = "https://github.com/kiwi0fruit/open-fonts/releases/download/${version}/open-fonts.tar.xz";
  downloadToTemp = true;
  recursiveHash = true;
  sha256 = "sha256-bSP9Flotoo3E5vRU3eKOUAPD2fmkWseWYWG4y0S07+4=";

  postFetch = ''
    tar xf $downloadedFile
    mkdir -p $out/share/fonts/truetype
    install open-fonts/*.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "A collection of beautiful free and open source fonts";
    homepage = "https://github.com/kiwi0fruit/open-fonts";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
