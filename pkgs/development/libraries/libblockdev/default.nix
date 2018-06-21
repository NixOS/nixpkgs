{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk-doc, libxslt, docbook_xsl
, docbook_xml_dtd_43, python3, gobjectIntrospection, glib, libudev, kmod, parted, libyaml
, cryptsetup, devicemapper, dmraid, utillinuxMinimal, libbytesize, libndctl, nss, volume_key
, minimal ? false
}:

let
  version = "2.18";
in stdenv.mkDerivation rec {
  name = "libblockdev-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    rev = "${version}-1";
    sha256 = "03gbmji401nz1sff2zp61dhal80qls4blqwadj2p4ckbxdlmid4i";
  };

  outputs = [ "out" "dev" "devdoc" ];

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    autoreconfHook pkgconfig gtk-doc libxslt docbook_xsl docbook_xml_dtd_43 python3 gobjectIntrospection
  ];

  configureFlags = stdenv.lib.optionals minimal [
    "--without-btrfs"
    "--without-dm"
    "--without-dmraid"
    "--without-escrow"
    "--without-kbd"
    "--without-lvm"
    "--without-lvm_dbus"
    "--without-mpath"
    "--without-vdo"
  ];

  buildInputs = [
    glib libudev devicemapper kmod parted cryptsetup utillinuxMinimal libbytesize libndctl nss
  ] ++ stdenv.lib.optionals (!minimal) [ dmraid volume_key libyaml ];

  meta = with stdenv.lib; {
    description = "A library for manipulating block devices";
    homepage = http://storaged.org/libblockdev/;
    license = licenses.lgpl2Plus; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
