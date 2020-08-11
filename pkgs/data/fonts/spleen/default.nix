{ lib, fetchurl, mkfontscale }:

let
  pname = "spleen";
  version = "1.8.1";
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
  sha256 = "0m70gz1ywrhw8xfff9bgx1wv52z9fibdsmjcwhjhpd826zbz05w8";

  meta = with lib; {
    description = "Monospaced bitmap fonts";
    homepage = "https://www.cambus.net/spleen-monospaced-bitmap-fonts";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
