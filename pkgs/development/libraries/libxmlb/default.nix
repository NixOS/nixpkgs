{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, libuuid, gobject-introspection, gtk-doc, shared-mime-info, python3, docbook_xsl, docbook_xml_dtd_43 }:

stdenv.mkDerivation rec {
  name = "libxmlb-${version}";
  version = "0.1.6";

  outputs = [ "out" "lib" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libxmlb";
    rev = version;
    sha256 = "194slg11lp2i8zvc4a3zkzshps7qglzmrabp5k0r92rampx4dbwa";
  };

  nativeBuildInputs = [ meson ninja python3 pkgconfig gobject-introspection gtk-doc shared-mime-info docbook_xsl docbook_xml_dtd_43 ];

  buildInputs = [ glib libuuid ];

  mesonFlags = [
    "--libexecdir=${placeholder "out"}/libexec"
    "-Dgtkdoc=true"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A library to help create and query binary XML blobs";
    homepage = https://github.com/hughsie/libxmlb;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
