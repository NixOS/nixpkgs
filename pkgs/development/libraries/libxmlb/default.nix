{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
    # Fix darwin build, can be removed on next release
    # `--version-script` isn't supported by the macOS linker
    # https://github.com/hughsie/libxmlb/pull/119
    (fetchpatch {
      url = "https://github.com/hughsie/libxmlb/commit/d83aac5bd78cfbbfa2ecd428ff54b811071dfe4d.patch";
      sha256 = "sha256-UNRMbyNzdxfTZ8xV6J8a622hPnr3mowooP1q8Dg19yw=";
    })
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
    platforms = platforms.unix;
  };
}
