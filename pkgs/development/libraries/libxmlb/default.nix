{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, libuuid, gobject-introspection, gtk-doc, shared-mime-info, python3, docbook_xsl, docbook_xml_dtd_43 }:

stdenv.mkDerivation rec {
  name = "libxmlb-${version}";
  version = "0.1.9";

  outputs = [ "out" "lib" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libxmlb";
    rev = version;
    sha256 = "1rdpsssrwpx24snqb82hisjybnpz9fq91wbmxfi2s63xllzi14b6";
  };

  nativeBuildInputs = [ meson ninja python3 pkgconfig gobject-introspection gtk-doc shared-mime-info docbook_xsl docbook_xml_dtd_43 ];

  buildInputs = [ glib libuuid ];

  mesonFlags = [
    "--libexecdir=${placeholder "out"}/libexec"
    "-Dgtkdoc=true"
  ];

  preCheck = ''
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:${shared-mime-info}/share
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A library to help create and query binary XML blobs";
    homepage = https://github.com/hughsie/libxmlb;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
