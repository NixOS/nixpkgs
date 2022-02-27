{ stdenv
, lib
, fetchFromGitHub
, docbook_xml_dtd_43
, docbook_xsl
, glib
, gobject-introspection
, gtk-doc
, meson
, ninja
, pkg-config
, python3
, shared-mime-info
, nixosTests
, xz
}:

stdenv.mkDerivation rec {
  pname = "libxmlb";
  version = "0.3.7";

  outputs = [ "out" "lib" "dev" "devdoc" "installedTests" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libxmlb";
    rev = version;
    sha256 = "sha256-ZzA1YJYxTR91X79NU9dWd11Ze+PX2wuZeumuEuNdC48=";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook_xsl
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    python3
    shared-mime-info
  ];

  buildInputs = [
    glib
    xz
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
      installed-tests = nixosTests.installed-tests.libxmlb;
    };
  };

  meta = with lib; {
    description = "A library to help create and query binary XML blobs";
    homepage = "https://github.com/hughsie/libxmlb";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
