{ stdenv,
  fetchFromGitHub,
  which,
  autoreconfHook,
  autoconf,
  automake,
  libtool,
  yacc,
  bison,
  flex,
  glib,
  pkgconfig,
  json_c,
  xen,
  libvirt,
  xenSupport ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libvmi-${version}";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "libvmi";
    repo = "libvmi";
    rev = "6934e8a4758018983ec53ec791dd14a7d6ac31a9";
    sha256 = "0wbi2nasb1gbci6cq23g6kq7i10rwi1y7r44rl03icr5prqjpdyv";
  };

  buildInputs = [ glib which libvirt json_c ] ++ (optional xenSupport xen);
  nativeBuildInputs = [ autoreconfHook yacc bison flex libtool autoconf automake pkgconfig ];

  configureFlags = optional (!xenSupport) "--disable-xen";

  meta = with stdenv.lib; {
    homepage = "http://libvmi.com/";
    description = "A C library for virtual machine introspection";
    longDescription = ''
      LibVMI is a C library with Python bindings that makes it easy to monitor the low-level
      details of a running virtual machine by viewing its memory, trapping on hardware events,
      and accessing the vCPU registers.
    '';
    license = with licenses; [ gpl3 lgpl3 ];
    maintainers = with maintainers; [ lschuermann ];
  };
}
