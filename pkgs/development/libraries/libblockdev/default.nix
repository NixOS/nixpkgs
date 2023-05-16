<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, gtk-doc
, docbook_xml_dtd_43
, python3
, gobject-introspection
, glib
, udev
, kmod
, parted
, cryptsetup
, lvm2
, util-linux
, libbytesize
, libndctl
, nss
, volume_key
, libxslt
, docbook_xsl
, gptfdisk
, libyaml
, autoconf-archive
, thin-provisioning-tools
, makeBinaryWrapper
, e2fsprogs
, libnvme
, keyutils
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libblockdev";
  version = "3.0.3";
=======
{ lib, stdenv, fetchFromGitHub, substituteAll, autoreconfHook, pkg-config, gtk-doc
, docbook_xml_dtd_43, python3, gobject-introspection, glib, udev, kmod, parted
, cryptsetup, lvm2, dmraid, util-linux, libbytesize, libndctl, nss, volume_key
, libxslt, docbook_xsl, gptfdisk, libyaml, autoconf-archive
, thin-provisioning-tools, makeWrapper
}:
stdenv.mkDerivation rec {
  pname = "libblockdev";
  version = "2.28";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
<<<<<<< HEAD
    rev = "${finalAttrs.version}-1";
    hash = "sha256-vQ+JHMhfCNb5PALGL9FchRYPHGj+6oQpRfmmGS0ZczI=";
=======
    rev = "${version}-1";
    sha256 = "sha256-6MrM3psLqMcpf4haaEHg3FwrhUDz5h/DeY1w96T0UlE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" "devdoc" ];

<<<<<<< HEAD
=======
  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      sgdisk = "${gptfdisk}/bin/sgdisk";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
<<<<<<< HEAD
    autoconf-archive
    autoreconfHook
    docbook_xsl
    docbook_xml_dtd_43
    gobject-introspection
    gtk-doc
    libxslt
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    cryptsetup
    e2fsprogs
    glib
    gptfdisk
    keyutils
    kmod
    libbytesize
    libndctl
    libnvme
    libyaml
    lvm2
    nss
    parted
    udev
    util-linux
    volume_key
=======
    autoreconfHook pkg-config gtk-doc libxslt docbook_xsl docbook_xml_dtd_43
    python3 gobject-introspection autoconf-archive makeWrapper
  ];

  buildInputs = [
    glib udev kmod parted gptfdisk cryptsetup lvm2 dmraid util-linux libbytesize
    libndctl nss volume_key libyaml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postInstall = ''
    wrapProgram $out/bin/lvm-cache-stats --prefix PATH : \
      ${lib.makeBinPath [ thin-provisioning-tools ]}
  '';

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/storaged-project/libblockdev/raw/${finalAttrs.src.rev}/NEWS.rst";
    description = "A library for manipulating block devices";
    homepage = "http://storaged.org/libblockdev/";
    license = with lib.licenses; [ lgpl2Plus gpl2Plus ]; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with lib.maintainers; [ johnazoidberg ];
    platforms = lib.platforms.linux;
  };
})
=======
  meta = with lib; {
    description = "A library for manipulating block devices";
    homepage = "http://storaged.org/libblockdev/";
    changelog = "https://github.com/storaged-project/libblockdev/raw/${src.rev}/NEWS.rst";
    license = with licenses; [ lgpl2Plus gpl2Plus ]; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
