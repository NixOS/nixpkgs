{ stdenv, xen, which, autoreconfHook, fetchFromGitHub, yacc, bison, flex, glib, libtool, autoconf, automake, pkgconfig, libvirt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libvmi-${version}";
  version = "${stdenv.lib.strings.substring 0 7 rev}-2017-05-27";
  rev = "3e4114a64f012f1d3e2eb660bc65dcd130295d49";

  src = fetchFromGitHub {
    inherit rev;
    owner = "libvmi";
    repo = "libvmi";
    sha256 = "0vbmrj0ij19i55afkqj64q7sgh0scpwk3c99qx6p6gn1qcy2wdss";
  };

  buildInputs = [ glib xen which libvirt ];
  nativeBuildInputs = [ autoreconfHook yacc bison flex libtool autoconf automake pkgconfig ];

  meta = with stdenv.lib; {
    homepage = "http://libvmi.com/";
    description = "A C library for virtual machine introspection";
    longDescription = ''
      LibVMI is a C library with Python bindings that makes it easy to monitor the low-level
      details of a running virtual machine by viewing its memory, trapping on hardware events,
      and accessing the vCPU registers.
    '';
    license = [ licenses.gpl3 licenses.lgpg ];
    maintainers = with maintainers; [ eleanor ];
  };
}
