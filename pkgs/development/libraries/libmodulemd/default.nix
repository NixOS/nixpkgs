{ stdenv
, fetchFromGitHub
, pkgconfig
, meson
, ninja
, gobject-introspection
, python3
, libyaml
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, glib
}:

stdenv.mkDerivation rec {
  pname = "libmodulemd";
  version = "2.6.0";

  outputs = [ "out" "devdoc" "py" ];

  src = fetchFromGitHub {
    owner = "fedora-modularity";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0gizfmzs6jrzb29lwcimm5dq3027935xbzwgkbvbp67zcmjd3y5i";
  };

  patches = [
    ./pygobject-dir.patch
  ];

  nativeBuildInputs = [
    pkgconfig
    meson
    ninja
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
    gobject-introspection
  ];

  buildInputs = [
    libyaml
    glib
  ];

  mesonFlags = [
    "-Ddeveloper_build=false"
    "-Dpygobject_override_dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  meta = with stdenv.lib; {
    description = "C Library for manipulating module metadata files";
    homepage = "https://github.com/fedora-modularity/libmodulemd";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
