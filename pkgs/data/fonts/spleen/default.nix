{ lib, fetchurl }:

let
  pname = "spleen";
  version = "1.0.5";
in fetchurl rec {
  name = "${pname}-${version}";
  url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    tar xf $downloadedFile --strip=1
    d="$out/share/fonts/X11/misc/spleen"
    gzip -n9 *.pcf
    install -Dm644 *.pcf.gz  -t $d
    install -Dm644 *.bdf -t $d
    install -m644 fonts.alias-spleen $d/fonts.alias
  '';
  sha256 = "0144a0lkkl5qx0a8sapymcayj5lp5cs9nfgpbmg3427n41pkqfbb";

  meta = with lib; {
    description = "Monospaced bitmap fonts";
    homepage = https://www.cambus.net/spleen-monospaced-bitmap-fonts;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
