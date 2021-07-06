{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_45
, glib
}:

stdenv.mkDerivation rec {
  pname = "libportal";
  version = "0.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "fuYZWGkdazq6H0rThqpF6KIcvwgc17o+CiISb1LjBso=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_45
  ];

  propagatedBuildInputs = [
    glib
  ];

  meta = with lib; {
    description = "Flatpak portal library";
    homepage = "https://github.com/flatpak/libportal";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
