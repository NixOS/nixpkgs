{ lib, stdenv
, substituteAll
, fetchFromGitHub
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
, docbook_xml_dtd_412
, glib
}:

stdenv.mkDerivation rec {
  pname = "libmodulemd";
  version = "2.14.0";

  outputs = [ "bin" "out" "dev" "devdoc" "man" "py" ];

  src = fetchFromGitHub {
    owner = "fedora-modularity";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-ccLk8O0UJwy7WZYr5Bq2XqaSFNe4i7HQehmVoB5C2Yg=";
  };

  patches = [
    # Use proper glib devdoc path.
    (substituteAll {
      src = ./glib-devdoc.patch;
      glib_devdoc = glib.devdoc;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gtk-doc
    docbook-xsl-nons
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
    "-Dgobject_overrides_dir_py3=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  postFixup = ''
    # Python overrides depend our own typelibs and other packages
    mkdir -p "$py/nix-support"
    echo "$out ${python3.pkgs.pygobject3} ${python3.pkgs.six}" > "$py/nix-support/propagated-build-inputs"
  '';

  meta = with lib; {
    description = "C Library for manipulating module metadata files";
    homepage = "https://github.com/fedora-modularity/libmodulemd";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux ++ platforms.darwin ;
  };
}
