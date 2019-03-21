{ stdenv, fetchFromGitHub, glib, xorg, gdk_pixbuf, pulseaudio,
  mobile-broadband-provider-info, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-lib";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0g84v1adnnyqc1mv45n3wlvnivkm1fi8ywszzgwx8irl3iddfvxv";
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

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Go bindings for Deepin Desktop Environment development";
    homepage = https://github.com/linuxdeepin/go-lib;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
