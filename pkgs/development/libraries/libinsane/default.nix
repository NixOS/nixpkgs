{ stdenv
, lib
, meson
, ninja
, fetchFromGitLab
, pkg-config
, glib
, docbook_xsl
, sane-backends
, gobject-introspection
, vala
, gtk-doc
, valgrind
, doxygen
, cunit
}:

stdenv.mkDerivation rec {
  pname = "libinsane";
  version = "1.0.8";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "libinsane";
    group = "World";
    owner = "OpenPaperwork";
    rev = version;
    sha256 = "0mcvqpixilzs4d4afkbxa1nqm6ddmhpaz5j56pfvc5wpv6s99h44";
  };

  nativeBuildInputs = [ meson pkg-config ninja doxygen gtk-doc docbook_xsl gobject-introspection vala ];

  buildInputs = [ sane-backends glib ];

  checkInputs = [ cunit valgrind ];

  doCheck = true;

  meta = {
    description = "Crossplatform access to image scanners (paper eaters only)";
    homepage = "https://openpaper.work/en/projects/";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.symphorien ];
  };
}
