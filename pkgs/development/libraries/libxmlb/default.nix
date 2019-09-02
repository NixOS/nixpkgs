{ stdenv
, fetchFromGitHub
, fetchpatch
, docbook_xml_dtd_43
, docbook_xsl
, glib
, gobject-introspection
, gtk-doc
, libuuid
, meson
, ninja
, pkgconfig
, python3
, shared-mime-info
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "libxmlb";
  version = "0.1.11";

  outputs = [ "out" "lib" "dev" "devdoc" "installedTests" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libxmlb";
    rev = version;
    sha256 = "1503v76w7543snqyjxykiqa5va62zb0ccn3jlw0gpdx8973v80mr";
  };

  patches = [
    # Fix installed tests
    # https://github.com/hughsie/libxmlb/pull/2
    (fetchpatch {
      url = "https://github.com/hughsie/libxmlb/commit/78850c8b0f644f729fa21e2bf9ebed0d9d6010f3.diff";
      sha256 = "0zw7c6vy8hscln7za7ijqd9svirach3zdskvbzyxxcsm3xcwxpjm";
    })

    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook_xsl
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkgconfig
    (python3.withPackages (pkgs: with pkgs; [ setuptools ]))
    shared-mime-info
  ];

  buildInputs = [
    glib
    libuuid
  ];

  mesonFlags = [
    "--libexecdir=${placeholder "out"}/libexec"
    "-Dgtkdoc=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  preCheck = ''
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:${shared-mime-info}/share
  '';

  doCheck = true;

  passthru = {
    tests = {
      installed-tests = nixosTests.libxmlb;
    };
  };

  meta = with stdenv.lib; {
    description = "A library to help create and query binary XML blobs";
    homepage = https://github.com/hughsie/libxmlb;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
