{ stdenv, fetchFromGitHub, glib, xorg, gdk_pixbuf, pulseaudio,
  mobile-broadband-provider-info
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-lib";
  version = "1.2.16.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0dk6k53in3ffwwvkr0sazfk83rf4fyc6rvb6k8fi2n3qj4gp8xd2";
  };

  buildInputs = [
    glib
    xorg.libX11
    gdk_pixbuf
    pulseaudio
    mobile-broadband-provider-info
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "GOSITE_DIR=$(out)/share/go"
  ];

  meta = with stdenv.lib; {
    description = "Go bindings for Deepin Desktop Environment development";
    homepage = https://github.com/linuxdeepin/go-lib;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
