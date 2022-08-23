{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, intltool
, meson
, ninja
, itstool
, libxml2
, python3
, gtk3
, json-glib
, isocodes
, openssl
, gnome
, gobject-introspection
, vala
, libgee
, sqlite
, gtk-doc
, yelp-tools
, mysqlSupport ? false
, libmysqlclient ? null
, postgresSupport ? false
, postgresql ? null
}:

assert mysqlSupport -> libmysqlclient != null;
assert postgresSupport -> postgresql != null;

stdenv.mkDerivation rec {
  pname = "libgda";
  version = "6.0.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0w564z7krgjk19r39mi5qn4kggpdg9ggbyn9pb4aavb61r14npwr";
  };

  patches = [
    # Fix undefined behavior
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libgda/-/commit/657b2f8497da907559a6769c5b1d2d7b5bd40688.patch";
      sha256 = "Qx4S9KQsTAr4M0QJi0Xr5kKuHSp4NwZJHoRPYyxIyTk=";
    })

    # Fix building vapi
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libgda/-/commit/57f618a3b2a3758ee3dcbf9bbdc566122dd8566d.patch";
      sha256 = "pyfymUd61m1kHaGyMbUQMma+szB8mlqGWwcFBBQawf8=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    meson
    ninja
    itstool
    libxml2
    python3
    gobject-introspection
    vala
    gtk-doc
    yelp-tools
  ];

  buildInputs = [
    gtk3
    json-glib
    isocodes
    openssl
    libgee
    sqlite
  ] ++ lib.optionals mysqlSupport [
    libmysqlclient
  ] ++ lib.optionals postgresSupport [
    postgresql
  ];

  postPatch = ''
    patchShebangs \
      providers/raw_spec.py \
      providers/mysql/gen_bin.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "libgda6";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Database access library";
    homepage = "https://www.gnome-db.org/";
    license = with licenses; [
      # library
      lgpl2Plus
      # CLI tools
      gpl2Plus
    ];
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
