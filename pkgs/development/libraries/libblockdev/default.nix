{ lib, stdenv, fetchFromGitHub, fetchpatch, substituteAll, autoreconfHook, pkg-config, gtk-doc
, docbook_xml_dtd_43, python3, gobject-introspection, glib, udev, kmod, parted
, cryptsetup, lvm2, dmraid, util-linux, libbytesize, libndctl, nss, volume_key
, libxslt, docbook_xsl, gptfdisk, libyaml, autoconf-archive
, thin-provisioning-tools, makeWrapper
}:
stdenv.mkDerivation rec {
  pname = "libblockdev";
  version = "2.25";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    rev = "${version}-1";
    sha256 = "sha256-eHUHTogKoNrnwwSo6JaI7NMxVt9JeMqfWyhR62bDMuQ=";
  };

  outputs = [ "out" "dev" "devdoc" ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      sgdisk = "${gptfdisk}/bin/sgdisk";
    })

    # fix build with glib 2.68 (g_memdup is deprecated)
    # https://github.com/storaged-project/libblockdev/pull/623
    (fetchpatch {
      url = "https://github.com/storaged-project/libblockdev/commit/5528baef6ccc835a06c45f9db34a2c9c3f2dd940.patch";
      sha256 = "jxq4BLeyTMeNvBvY8k8QXIvYSJ2Gah0J75pq6FpG7PM=";
    })
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    autoreconfHook pkg-config gtk-doc libxslt docbook_xsl docbook_xml_dtd_43
    python3 gobject-introspection autoconf-archive makeWrapper
  ];

  buildInputs = [
    glib udev kmod parted gptfdisk cryptsetup lvm2 dmraid util-linux libbytesize
    libndctl nss volume_key libyaml
  ];

  postInstall = ''
    wrapProgram $out/bin/lvm-cache-stats --prefix PATH : \
      ${lib.makeBinPath [ thin-provisioning-tools ]}
  '';

  meta = with lib; {
    description = "A library for manipulating block devices";
    homepage = "http://storaged.org/libblockdev/";
    license = with licenses; [ lgpl2Plus gpl2Plus ]; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.linux;
  };
}
