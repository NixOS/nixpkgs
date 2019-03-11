{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk-doc, libxslt, docbook_xsl
, docbook_xml_dtd_43, python3, gobject-introspection, glib, udev, kmod, parted, libyaml
, cryptsetup, lvm2, dmraid, utillinux, libbytesize, libndctl, nss, volume_key
}:

let
  version = "2.20";
in stdenv.mkDerivation rec {
  name = "libblockdev-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    rev = "${version}-1";
    sha256 = "13xy8vx2dnnxczpnwapchc5ncigcxb2fhpmrmglbpkjqmhn2zbdj";
  };

  outputs = [ "out" "dev" "devdoc" ];

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    autoreconfHook pkgconfig gtk-doc libxslt docbook_xsl docbook_xml_dtd_43 python3 gobject-introspection
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
