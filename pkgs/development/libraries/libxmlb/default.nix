{ stdenv
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
}:

stdenv.mkDerivation rec {
  pname = "libxmlb";
  version = "0.2.1";

  outputs = [ "out" "lib" "dev" "devdoc" "installedTests" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libxmlb";
    rev = version;
    sha256 = "XD66YfD8fjaqp5pkcR8qNh7Srjh+atAIC2qkDTF7KdM=";
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
    (python3.withPackages (pkgs: with pkgs; [ setuptools ]))
    shared-mime-info
  ];

  buildInputs = [
    glib
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

  meta = with stdenv.lib; {
    description = "A library to help create and query binary XML blobs";
    homepage = "https://github.com/hughsie/libxmlb";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
