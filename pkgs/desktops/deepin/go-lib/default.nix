{ stdenv
, fetchFromGitHub
, glib
, xorg
, gdk-pixbuf
, glibc
, isocodes
, pulseaudio
, mobile-broadband-provider-info
, deepin
}:

stdenv.mkDerivation rec {
  pname = "go-lib";
  version = "5.5.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "128909as236yn6gf92dfwa08zpj5nl5j7wwk2ixfnqgfir66hnwh";
  };

  nativeBuildInputs = [
    deepin.setupHook
  ];

  buildInputs = [
    glib
    xorg.libX11
    gdk-pixbuf
    pulseaudio
    mobile-broadband-provider-info
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    fixPath ${glibc} /usr/share/locale/locale.alias locale/locale.go
    fixPath ${isocodes} /usr/share/xml/iso-codes/iso_3166.xml iso/country.go

    substituteInPlace iso/country.go --replace /usr/share/locale /run/current-system/sw/share/locale
  '';

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
