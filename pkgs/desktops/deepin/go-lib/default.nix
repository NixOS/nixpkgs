{ stdenv, fetchFromGitHub, glib, xorg, gdk_pixbuf, pulseaudio,
  mobile-broadband-provider-info, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-lib";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "090l33y79gdj2xy1bhk2ksl6hvmsfhmx0bhygm4y4d0iqckf2x2m";
  };

  buildInputs = [
    glib
    xorg.libX11
    gdk_pixbuf
    pulseaudio
    mobile-broadband-provider-info
  ];

  installPhase = ''
    mkdir -p $out/share/go/src/pkg.deepin.io/lib
    cp -a * $out/share/go/src/pkg.deepin.io/lib

    rm -r $out/share/go/src/pkg.deepin.io/lib/debian
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Go bindings for Deepin Desktop Environment development";
    homepage = https://github.com/linuxdeepin/go-lib;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
