{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk-doc, libxslt, docbook_xsl
, docbook_xml_dtd_43, python3, gobjectIntrospection, glib, udev, kmod, parted, libyaml
, cryptsetup, lvm2, dmraid, utillinux, libbytesize, libndctl, nss, volume_key
}:

let
  version = "2.19";
in stdenv.mkDerivation rec {
  name = "libblockdev-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    rev = "${version}-1";
    sha256 = "1ny31vaarzbpw0h863p2r5cvjsfs77d33nnisf8bhjc6ps6js3ys";
  };

  outputs = [ "out" "dev" "devdoc" ];

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    autoreconfHook pkgconfig gtk-doc libxslt docbook_xsl docbook_xml_dtd_43 python3 gobjectIntrospection
  ];

  buildInputs = [
    glib udev kmod parted cryptsetup lvm2 dmraid utillinux libbytesize libndctl nss volume_key libyaml
  ];

  meta = with stdenv.lib; {
    description = "A library for manipulating block devices";
    homepage = http://storaged.org/libblockdev/;
    license = licenses.lgpl2Plus; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
