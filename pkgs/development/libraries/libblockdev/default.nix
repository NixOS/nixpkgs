{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk-doc, libxslt, docbook_xsl
, python3, gobjectIntrospection, glib, libudev, kmod, parted, cryptsetup
, devicemapper, dmraid, utillinux, libbytesize, nss, volume_key
}:

let
  version = "2.16";
in stdenv.mkDerivation rec {
  name = "libblockdev-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    rev = "${version}-1";
    sha256 = "02jdvafjbd280vz2mg5488xwdl595yyajaffrpfmfzbva513sxxc";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    autoreconfHook pkgconfig gtk-doc libxslt docbook_xsl python3 gobjectIntrospection
  ];

  buildInputs = [
    glib libudev kmod parted cryptsetup devicemapper dmraid utillinux libbytesize nss volume_key
  ];

  meta = with stdenv.lib; {
    description = "A library for manipulating block devices";
    homepage = http://storaged.org/libblockdev/;
    license = licenses.lgpl2Plus; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
