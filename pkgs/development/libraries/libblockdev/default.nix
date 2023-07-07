{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gtk-doc
, docbook_xml_dtd_43, python3, gobject-introspection, glib, udev, kmod, parted
, cryptsetup, lvm2, util-linux, libbytesize, libndctl, nss, volume_key
, libxslt, docbook_xsl, gptfdisk, libyaml, autoconf-archive
, thin-provisioning-tools, makeWrapper, e2fsprogs, libnvme, keyutils
}:
stdenv.mkDerivation rec {
  pname = "libblockdev";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    rev = "${version}-1";
    sha256 = "sha256-WnHcRKRxfdSRmOW2K/vn1WQ4iPm0uS0Td0cWXaeo5hk=";
  };

  outputs = [ "out" "dev" "devdoc" ];

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    autoreconfHook pkg-config gtk-doc libxslt docbook_xsl docbook_xml_dtd_43
    python3 gobject-introspection autoconf-archive makeWrapper
  ];

  buildInputs = [
    e2fsprogs glib udev keyutils kmod parted gptfdisk cryptsetup lvm2 util-linux libbytesize
    libndctl libnvme nss volume_key libyaml
  ];

  postInstall = ''
    wrapProgram $out/bin/lvm-cache-stats --prefix PATH : \
      ${lib.makeBinPath [ thin-provisioning-tools ]}
  '';

  meta = with lib; {
    description = "A library for manipulating block devices";
    homepage = "http://storaged.org/libblockdev/";
    changelog = "https://github.com/storaged-project/libblockdev/raw/${src.rev}/NEWS.rst";
    license = with licenses; [ lgpl2Plus gpl2Plus ]; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.linux;
  };
}
