{ lib, stdenv
, fetchFromGitLab
, fetchpatch
, pkg-config
, glib
, sqlite
, gobject-introspection
, vala
, autoconf
, automake
, libtool
, gettext
, dbus
, gtk3
, json-glib
, librdf_raptor2
, pythonSupport ? true
, python3
}:

stdenv.mkDerivation rec {
  pname = "zeitgeist";
  version = "1.0.3";

  outputs = [ "out" "lib" "dev" "man" ] ++ lib.optional pythonSupport "py";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0y6fyzxl5np4yskcxibd0p03h619w9ir907nhf40h02y0pk1kgkp";
  };

  patches = [
    # Fix build with Vala 0.52
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/zeitgeist/zeitgeist/commit/64ac3a6f94cd299e5e14945dc31b48f009dec152.patch";
      sha256 = "Dw1kNE3JoFdmgcQ0eFoFLYvmxlPjXNj56Jkn2meINz4=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    gettext
    gobject-introspection
    vala
    python3
  ];

  buildInputs = [
    glib
    sqlite
    dbus
    gtk3
    json-glib
    librdf_raptor2
    python3.pkgs.rdflib
  ];

  configureFlags = [
    "--disable-telepathy"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs data/ontology2code
  '';

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  postFixup = lib.optionalString pythonSupport ''
    moveToOutput lib/${python3.libPrefix} "$py"
  '';

  meta = with lib; {
    description = "A service which logs the users’s activities and events";
    homepage = "https://zeitgeist.freedesktop.org/";
    maintainers = teams.freedesktop.members ++ (with maintainers; [ ]);
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
