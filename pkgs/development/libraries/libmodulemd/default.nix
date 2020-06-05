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
    # https://github.com/fedora-modularity/libmodulemd/pull/469
    (fetchpatch {
      url = "https://github.com/fedora-modularity/libmodulemd/commit/f72a4bea092f4d84cfc48a3e820eb10270e828d0.patch";
      sha256 = "7/76N9ZQ7qv/DjsaMCL+YWPDzarH1JWW4Sg5HzBJLuc=";
    })
    (fetchpatch {
      url = "https://github.com/fedora-modularity/libmodulemd/commit/021ab08006b5cf601ce153174fdf403b910b8273.patch";
      sha256 = "JibEmxMiTmu3ShhWLIWfMCtu3c30UcHqXmX9b+2VZXw=";
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
    "-Dgobject_overrides_dir_py3=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  postFixup = ''
    # Python overrides depend our own typelibs and other packages
    mkdir -p "$py/nix-support"
    echo "$out ${python3.pkgs.pygobject3} ${python3.pkgs.six}" > "$py/nix-support/propagated-build-inputs"
  '';

  meta = with stdenv.lib; {
    description = "C Library for manipulating module metadata files";
    homepage = "https://github.com/fedora-modularity/libmodulemd";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
