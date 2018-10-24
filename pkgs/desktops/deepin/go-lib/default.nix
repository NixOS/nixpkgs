{ stdenv, fetchFromGitHub, glib, xorg, gdk_pixbuf, pulseaudio,
  mobile-broadband-provider-info
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-lib";
  version = "1.2.16.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0nl35dm0bdca38qhnzdpsv6b0vds9ccvm4c86rs42a7c6v655b1q";
  };

  buildInputs = [
    glib
    xorg.libX11
    gdk_pixbuf
    pulseaudio
    mobile-broadband-provider-info
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Go bindings for Deepin Desktop Environment development";
    homepage = https://github.com/linuxdeepin/go-lib;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
