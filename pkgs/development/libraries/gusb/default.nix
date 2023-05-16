<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, meson
, ninja
, pkg-config
, gobject-introspection
, gi-docgen
, python3
, glib
, libusb1
, json-glib
, vala
, hwdata
, umockdev
}:

let
  pythonEnv = python3.pythonForBuild.withPackages (ps: with ps; [
=======
{ lib, stdenv, fetchurl, substituteAll, meson, ninja, pkg-config, gettext, gobject-introspection
, gtk-doc, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_44, python3
, glib, libusb1, vala, hwdata
}:

let
  pythonEnv = python3.pythonForBuild.withPackages(ps: with ps; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    setuptools
  ]);
in
stdenv.mkDerivation rec {
  pname = "gusb";
<<<<<<< HEAD
  version = "0.4.6";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libgusb";
    rev = "refs/tags/${version}";
    hash = "sha256-CtB9+5dDs+l05NyIFkKJpS1x3zHSykhLW3HiIM0RUWY=";
=======
  version = "0.3.10";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/libgusb-${version}.tar.xz";
    sha256 = "sha256-DrC5qw+LugxZYxyAnDe2Fu806zyOAAsLm3HPEeSTG9w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (substituteAll {
      src = ./fix-python-path.patch;
      python = "${pythonEnv}/bin/python3";
    })
  ];

<<<<<<< HEAD
  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gi-docgen
    vala
  ];

  # all required in gusb.pc
  propagatedBuildInputs = [
    glib
    libusb1
    json-glib
  ];

  mesonFlags = [
    (lib.mesonBool "tests" doCheck)
    (lib.mesonOption "usb_ids" "${hwdata}/share/hwdata/usb.ids")
  ];

  checkInputs = [
    umockdev
=======
  nativeBuildInputs = [
    meson ninja pkg-config gettext pythonEnv
    gtk-doc docbook_xsl docbook_xml_dtd_412 docbook_xml_dtd_44
    gobject-introspection vala
  ];
  buildInputs = [ glib ];

  propagatedBuildInputs = [ libusb1 ];

  mesonFlags = [
    "-Dusb_ids=${hwdata}/share/hwdata/usb.ids"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = false; # tests try to access USB

<<<<<<< HEAD
  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    ls -la "$out/share/doc"
    moveToOutput "share/doc" "$devdoc"
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "GLib libusb wrapper";
    homepage = "https://github.com/hughsie/libgusb";
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
