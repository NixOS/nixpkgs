{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gtk-doc,
  docbook_xml_dtd_43,
  python3,
  gobject-introspection,
  glib,
  udev,
  kmod,
  parted,
  cryptsetup,
  lvm2,
  util-linux,
  libbytesize,
  libndctl,
  nss,
  volume_key,
  libxslt,
  docbook_xsl,
  gptfdisk,
  libyaml,
  autoconf-archive,
  thin-provisioning-tools,
  makeBinaryWrapper,
  e2fsprogs,
  libnvme,
  keyutils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libblockdev";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    rev = "${finalAttrs.version}-1";
    hash = "sha256-WCMedMkaMMhZbB3iJu3c+CTT3AvOjzOSYP45J+NQEDQ=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
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
  ];

  postInstall = ''
    wrapProgram $out/bin/lvm-cache-stats --prefix PATH : \
      ${lib.makeBinPath [ thin-provisioning-tools ]}
  '';

  meta = {
    changelog = "https://github.com/storaged-project/libblockdev/raw/${finalAttrs.src.rev}/NEWS.rst";
    description = "Library for manipulating block devices";
    homepage = "http://storaged.org/libblockdev/";
    license = with lib.licenses; [
      lgpl2Plus
      gpl2Plus
    ]; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with lib.maintainers; [ johnazoidberg ];
    platforms = lib.platforms.linux;
  };
})
