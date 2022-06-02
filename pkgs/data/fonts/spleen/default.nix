{ lib, fetchurl, mkfontscale }:

let
  pname = "spleen";
  version = "1.9.1";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    tar xvf $downloadedFile --strip=1
    d="$out/share/fonts/misc"
    install -D -m 644 *.{pcf,bdf,otf} -t "$d"
    install -D -m 644 *.psfu -t "$out/share/consolefonts"
    install -m644 fonts.alias-spleen $d/fonts.alias

    # create fonts.dir so NixOS xorg module adds to fp
    ${mkfontscale}/bin/mkfontdir "$d"
  '';
  sha256 = "sha256-6Imsa0ku8On63di0DOo0QxBa0t+tbtPRxM531EIiG94=";

  meta = with lib; {
    description = "Monospaced bitmap fonts";
    homepage = "https://www.cambus.net/spleen-monospaced-bitmap-fonts";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
