{ lib, fetchurl, mkfontdir }:

let
  pname = "spleen";
  version = "1.6.0";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    tar xvf $downloadedFile --strip=1
    d="$out/share/fonts/X11/misc/spleen"
    install -Dm644 *.{pcf.gz,psfu,bdf} -t $d
    install -m644 fonts.alias-spleen $d/fonts.alias

    # create fonts.dir so NixOS xorg module adds to fp
    ${mkfontdir}/bin/mkfontdir $d
  '';
  sha256 = "0h9gj7syn87hl5rhwckih92r228zac6b1dvh3034caml8ad3fyla";

  meta = with lib; {
    description = "Monospaced bitmap fonts";
    homepage = https://www.cambus.net/spleen-monospaced-bitmap-fonts;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
