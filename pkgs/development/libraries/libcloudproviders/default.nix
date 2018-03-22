{ stdenv, fetchurl, pkgconfig, meson, ninja, gtk-doc, docbook_xsl, glib }:

# TODO: Add installed tests once https://gitlab.gnome.org/Incubator/libcloudproviders/issues/4 is fixed

let
  pname = "libcloudproviders";
  version = "0.2.5";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://gitlab.gnome.org/Incubator/${pname}/repository/archive.tar.gz?ref=${version}";
    sha256 = "1c3vfg8wlsv0fmi1lm9qhsqdvp4k33yvwn6j680rh49laayf7k3g";
  };

  outputs = [ "out" "dev" "devdoc" ];

  mesonFlags = [
    "-Denable-gtk-doc=true"
  ];

  nativeBuildInputs = [ meson ninja pkgconfig gtk-doc docbook_xsl ];

  buildInputs = [ glib ];

  meta = with stdenv.lib; {
    description = "DBus API that allows cloud storage sync clients to expose their services";
    homepage = https://gitlab.gnome.org/Incubator/libcloudproviders;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
