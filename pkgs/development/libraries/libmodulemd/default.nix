{ stdenv
, substituteAll
, fetchFromGitHub
, fetchpatch
, pkg-config
, meson
, ninja
, gobject-introspection
, python3
, libyaml
, rpm
, file
, gtk-doc
, docbook-xsl-nons
, help2man
, docbook_xml_dtd_412
, glib
}:

stdenv.mkDerivation rec {
  pname = "libmodulemd";
  version = "2.9.2";

  outputs = [ "bin" "out" "dev" "devdoc" "man" "py" ];

  src = fetchFromGitHub {
    owner = "fedora-modularity";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "dm0uvzM5v1zDQVkonHbrT9l9ICnXZbCSiLRCMZRxhXY=";
  };

  patches = [
    # Use proper glib devdoc path.
    (substituteAll {
      src = ./glib-devdoc.patch;
      glib_devdoc = glib.devdoc;
    })

    # Install pygobject overrides to our prefix instead of python3 one.
    # https://github.com/fedora-modularity/libmodulemd/pull/467
    (fetchpatch {
      url = "https://github.com/fedora-modularity/libmodulemd/commit/516cb64fd1488716a188add2715c8b3296960bd6.patch";
      sha256 = "ZWagkqKkD9CIkcYsKLtC0+qjLp80wH3taivUCn8jQbY=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gtk-doc
    docbook-xsl-nons
    help2man
    docbook_xml_dtd_412
    gobject-introspection
  ];

  buildInputs = [
    libyaml
    rpm
    file # for libmagic
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
