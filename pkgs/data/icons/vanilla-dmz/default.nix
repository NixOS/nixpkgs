{ stdenv, lib, fetchzip, xorg }:

stdenv.mkDerivation rec {
  name = "vanilla-dmz-${version}";
  version = "0.4.4";
  src = fetchzip {
    url = "http://ftp.de.debian.org/debian/pool/main/d/dmz-cursor-theme/dmz-cursor-theme_${version}.tar.gz";
    sha256 = "1l0c0svk7dy0d7icg7j2181wdn3fvks5gmyqnvjk749ppy5ks8mj";
  };
  buildInputs = [ xorg.xcursorgen ];
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
    license = licenses.cc-by-nc-sa-30;
    maintainers = with maintainers; [ cstrahan ];
  };
}
