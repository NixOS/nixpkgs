{ stdenvNoCC
, lib
, fetchzip
, xorg
, hicolor-icon-theme
}:

stdenvNoCC.mkDerivation rec {
  pname = "vanilla-dmz";
  version = "0.4.5";

  src = fetchzip {
    url = "mirror://debian/pool/main/d/dmz-cursor-theme/dmz-cursor-theme_${version}.tar.xz";
    sha256 = "14r8fri4byyzavzdifpga6118hxqjwpzd11xxj28s16zxcanq16m";
  };

  buildInputs = [
    xorg.xcursorgen
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  buildPhase = ''
    cd DMZ-White/pngs; ./make.sh; cd -
    cd DMZ-Black/pngs; ./make.sh; cd -
  '';

  installPhase = ''
    install -d $out/share/icons/Vanilla-DMZ/cursors
    cp -a DMZ-White/xcursors/* $out/share/icons/Vanilla-DMZ/cursors
    install -Dm644 DMZ-White/index.theme $out/share/icons/Vanilla-DMZ/index.theme

    install -d $out/share/icons/Vanilla-DMZ-AA/cursors
    cp -a DMZ-Black/xcursors/* $out/share/icons/Vanilla-DMZ-AA/cursors
    install -Dm644 DMZ-Black/index.theme $out/share/icons/Vanilla-DMZ-AA/index.theme
  '';

  meta = with lib; {
    homepage = "http://jimmac.musichall.cz";
    description = "A style neutral scalable cursor theme";
    platforms = platforms.all;
    license = licenses.cc-by-sa-30;
    maintainers = with maintainers; [ cstrahan ];
  };
}
