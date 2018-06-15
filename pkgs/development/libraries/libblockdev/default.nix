{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk-doc, libxslt, docbook_xsl
, docbook_xml_dtd_43, python3, gobjectIntrospection, glib, libudev, kmod, parted
, cryptsetup, devicemapper, dmraid, utillinux, libbytesize, libndctl, nss, volume_key
}:

let
  version = "2.17";
in stdenv.mkDerivation rec {
  name = "libblockdev-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    rev = "${version}-1";
    sha256 = "14f52cj2qcnm8i2zb57qfpdk3kij2gb3xgqkbvidmf6sjicq84z2";
  };

  outputs = [ "out" "dev" "devdoc" ];

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    autoreconfHook pkgconfig gtk-doc libxslt docbook_xsl docbook_xml_dtd_43 python3 gobjectIntrospection
  ];

  buildInputs = [
    glib libudev kmod parted cryptsetup devicemapper dmraid utillinux libbytesize libndctl nss volume_key
  ];

  meta = with stdenv.lib; {
    description = "A library for manipulating block devices";
    homepage = http://storaged.org/libblockdev/;
    license = licenses.lgpl2Plus; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
