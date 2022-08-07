{ stdenv
, lib
, fetchpatch
, substituteAll
, fetchurl
, pkg-config
, which
, autoreconfHook
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, python3
, ncurses
, nautilus
, gtk3
, gnome
}:

stdenv.mkDerivation rec {
  pname = "nautilus-python";
  version = "1.2.3";

  outputs = [ "out" "dev" "doc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "161050sx3sdxqcpjkjcpf6wl4kx0jydihga7mcvrj9c2f8ly0g07";
  };

  patches = [
    # Make PyGObject’s gi library available.
    (substituteAll {
      src = ./fix-paths.patch;
      pythonPaths = lib.concatMapStringsSep ", " (pkg: "'${pkg}/${python3.sitePackages}'") [
        python3.pkgs.pygobject3
      ];
    })

    # Fix build with Nautilus 43.
    # https://gitlab.gnome.org/GNOME/nautilus-python/-/merge_requests/9
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/nautilus-python/commit/1691b2eb88c8b9134c6fa06da0858f7b5bb74c72.patch";
      sha256 = "dY9KrLorYlGTbKSLObRmffJwJfHwz48kCsInGGByIOI=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    which
    autoreconfHook
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  buildInputs = [
    python3
    ncurses # required by python3
    python3.pkgs.pygobject3
    nautilus
    gtk3 # required by libnautilus-extension
  ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: nautilus-python-object.o:src/nautilus-python.h:61: multiple definition of
  #     `_PyNautilusMenu_Type'; nautilus-python.o:src/nautilus-python.h:61: first defined here
  # TODO: remove it once upstream fixes and releases:
  #   https://gitlab.gnome.org/GNOME/nautilus-python/-/merge_requests/7
  NIX_CFLAGS_COMPILE = "-fcommon";

  makeFlags = [
    "PYTHON_LIB_LOC=${python3}/lib"
  ];

  PKG_CONFIG_LIBNAUTILUS_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/lib/nautilus/extensions-4";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Python bindings for the Nautilus Extension API";
    homepage = "https://wiki.gnome.org/Projects/NautilusPython";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
