{ lib
, stdenv
, fetchurl
, dbus-glib
, glib
, python3
, pkg-config
, libxslt
, gobject-introspection
, vala
, glibcLocales
}:

stdenv.mkDerivation rec {
  pname = "telepathy-glib";
  version = "0.24.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${pname}-${version}.tar.gz";
    sha256 = "sKN013HN0IESXzjDq9B5ZXZCMBxxpUPVVeK/IZGSc/A=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    libxslt
    gobject-introspection
    vala
    python3
  ];

  buildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = [
    dbus-glib
    glib
  ];

  configureFlags = [
    "--enable-vala-bindings"
  ];

  LC_ALL = "en_US.UTF-8";

  enableParallelBuilding = true;

  preConfigure = ''
    substituteInPlace telepathy-glib/telepathy-glib.pc.in --replace Requires.private Requires
  '';

  meta = with lib; {
    homepage = "https://telepathy.freedesktop.org";
    platforms = platforms.unix;
    license = with licenses; [ bsd2 bsd3 lgpl21Plus ];
  };
}
