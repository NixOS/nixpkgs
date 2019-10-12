{ stdenv, fetchFromGitHub, substituteAll, autoreconfHook, pkgconfig, gtk-doc
, docbook_xml_dtd_43, python3, gobject-introspection, glib, udev, kmod, parted
, cryptsetup, lvm2, dmraid, utillinux, libbytesize, libndctl, nss, volume_key
, libxslt, docbook_xsl, gptfdisk, libyaml, autoconf-archive
, thin-provisioning-tools, makeWrapper
}:
stdenv.mkDerivation rec {
  pname = "libblockdev";
  version = "2.23";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    rev = "${version}-1";
    sha256 = "09gp9h05vy3llhnrg98gny8g57kgwnbi8522qyzjwyv7nmhs4zhz";
  };

  outputs = [ "out" "dev" "devdoc" ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      sgdisk = "${gptfdisk}/bin/sgdisk";
    })
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    autoreconfHook pkgconfig gtk-doc libxslt docbook_xsl docbook_xml_dtd_43
    python3 gobject-introspection autoconf-archive makeWrapper
  ];

  buildInputs = [
    glib udev kmod parted gptfdisk cryptsetup lvm2 dmraid utillinux libbytesize
    libndctl nss volume_key libyaml
  ];

  postInstall = ''
    wrapProgram $out/bin/lvm-cache-stats --prefix PATH : \
      ${stdenv.lib.makeBinPath [ thin-provisioning-tools ]}
  '';

  meta = with stdenv.lib; {
    description = "A library for manipulating block devices";
    homepage = "http://storaged.org/libblockdev/";
    license = with licenses; [ lgpl2Plus gpl2Plus ]; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.linux;
  };
}
