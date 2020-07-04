{ stdenv
, fetchFromGitHub
, glib
, xorg
, gdk-pixbuf
, pulseaudio
, mobile-broadband-provider-info
, deepin
}:

stdenv.mkDerivation rec {
  pname = "go-lib";
  version = "5.4.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "021sq7nzvfwsa5ccsb3vdjk53m7cf693xm4wkdkrkf8pja6vz94q";
  };

  buildInputs = [
    glib
    xorg.libX11
    gdk-pixbuf
    pulseaudio
    mobile-broadband-provider-info
  ];

  installPhase = ''
    mkdir -p $out/share/go/src/pkg.deepin.io/lib
    cp -a * $out/share/go/src/pkg.deepin.io/lib

    rm -r $out/share/go/src/pkg.deepin.io/lib/debian
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Go bindings for Deepin Desktop Environment development";
    homepage = "https://github.com/linuxdeepin/go-lib";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
