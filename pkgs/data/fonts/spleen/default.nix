{ lib, mkFont, fetchzip, mkfontscale }:

mkFont rec {
  pname = "spleen";
  version = "1.7.0";

  src = fetchzip {
    url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";
    sha256 = "02193806fp2dw4114y0j61skv8wb2z8r1zg3hp4g9i9v579jbwir";
  };

  /*
  postFetch = ''
    tar xvf $downloadedFile --strip=1
    d="$out/share/fonts/misc"
    install -D -m 644 *.{pcf,bdf,otf} -t "$d"
    install -D -m 644 *.psfu -t "$out/share/consolefonts"
    install -m644 fonts.alias-spleen $d/fonts.alias

    # create fonts.dir so NixOS xorg module adds to fp
    ${mkfontscale}/bin/mkfontdir "$d"
  '';
  */

  meta = with lib; {
    description = "Monospaced bitmap fonts";
    homepage = "https://www.cambus.net/spleen-monospaced-bitmap-fonts";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
