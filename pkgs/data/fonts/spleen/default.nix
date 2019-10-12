{ lib, fetchurl }:

let
  pname = "spleen";
  version = "1.3.0";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    tar xvf $downloadedFile --strip=1
    d="$out/share/fonts/X11/misc/spleen"
    gzip -n9 *.pcf
    install -Dm644 *.{pcf.gz,psfu,bdf} -t $d
    install -m644 fonts.alias-spleen $d/fonts.alias
  '';
  sha256 = "1l1ksl8xnz1yh7jl8h2g25a7wfm9xgj3lay8ddqzlxzydkkm110q";

  meta = with lib; {
    description = "Monospaced bitmap fonts";
    homepage = https://www.cambus.net/spleen-monospaced-bitmap-fonts;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
