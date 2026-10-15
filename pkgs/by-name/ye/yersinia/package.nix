{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchDebianPatch,
  autoreconfHook,
  pkg-config,
  ncurses,
  libpcap,
  libnet,
  # enable remote admin interface
  enableAdmin ? false,
}:

stdenv.mkDerivation {
  pname = "yersinia";
  version = "unstable-2022-11-20";

  src = fetchFromGitHub {
    owner = "tomac";
    repo = "yersinia";
    rev = "867b309eced9e02b63412855440cd4f5f7727431";
    sha256 = "sha256-VShg9Nzd8dzUNiqYnKcDzRgqjwar/8XRGEJCJL25aR0=";
  };

  patches = [
    (fetchDebianPatch {
      pname = "yersinia";
      version = "0.8.2";
      debianRevision = "2.3";
      patch = "fix-ftbfs.patch";
      hash = "sha256-qoD627fcIGmlWT2Uz+85tgIf7KtD11gtUu1N+Ol4T/A=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libpcap
    libnet
    ncurses
  ];

  autoreconfPhase = "./autogen.sh";

  configureFlags = [
    "--with-pcap-includes=${lib.getDev libpcap}/include"
    "--with-libnet-includes=${lib.getDev libnet}/include"
    "--disable-gtk"
  ]
  ++ lib.optional (!enableAdmin) "--disable-admin";

  makeFlags = [ "LDFLAGS=-lncurses" ];

  meta = {
    description = "Framework for layer 2 attacks";
    mainProgram = "yersinia";
    homepage = "https://github.com/tomac/yersinia";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ vdot0x23 ];
    # INSTALL and FAQ in this package seem a little outdated
    # so not sure, but it could work on openbsd, illumos, and freebsd
    # if you have a machine to test with, feel free to add these
    platforms = with lib.platforms; linux;
  };
}
