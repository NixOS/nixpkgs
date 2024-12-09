{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config
, ncurses, libpcap, libnet
# alpha version of GTK interface
, withGtk ? false, gtk2
# enable remote admin interface
, enableAdmin ? false
}:

stdenv.mkDerivation rec {
  pname = "yersinia";
  version = "unstable-2022-11-20";

  src = fetchFromGitHub {
    owner = "tomac";
    repo = pname;
    rev = "867b309eced9e02b63412855440cd4f5f7727431";
    sha256 = "sha256-VShg9Nzd8dzUNiqYnKcDzRgqjwar/8XRGEJCJL25aR0=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libpcap libnet ncurses ]
    ++ lib.optional withGtk gtk2;

  autoreconfPhase = "./autogen.sh";

  configureFlags = [
    "--with-pcap-includes=${libpcap}/include"
    "--with-libnet-includes=${libnet}/include"
  ]
  ++ lib.optional (!enableAdmin) "--disable-admin"
  ++ lib.optional (!withGtk) "--disable-gtk";

  makeFlags = [ "LDFLAGS=-lncurses" ];

  meta = with lib; {
    description = "Framework for layer 2 attacks";
    mainProgram = "yersinia";
    homepage = "https://github.com/tomac/yersinia";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vdot0x23 ];
    # INSTALL and FAQ in this package seem a little outdated
    # so not sure, but it could work on openbsd, illumos, and freebsd
    # if you have a machine to test with, feel free to add these
    platforms = with platforms; linux;
  };
}
