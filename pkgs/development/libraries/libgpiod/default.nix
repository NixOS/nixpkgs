{ lib, stdenv, fetchurl, autoreconfHook, autoconf-archive, pkgconfig, kmod
, enable-tools ? true
, enablePython ? false, python3, ncurses }:

stdenv.mkDerivation rec {
  pname = "libgpiod";
  version = "1.6.1";

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/snapshot/libgpiod-${version}.tar.gz";
    sha256 = "0p3vjf4zj137miix1gbi8rv6g4wvi8kmyhwwxyirw00ankxbxp1n";
  };

  patches = [
    # cross compiling fix
    # https://github.com/brgl/libgpiod/pull/45
    ./0001-Drop-AC_FUNC_MALLOC-and-_REALLOC-and-check-for-them-.patch
  ];

  buildInputs = [ kmod ] ++ lib.optionals enablePython [ python3 ncurses ];
  nativeBuildInputs = [
    autoconf-archive
    pkgconfig
    autoreconfHook
  ];

  configureFlags = [
    "--enable-tools=${if enable-tools then "yes" else "no"}"
    "--enable-bindings-cxx"
    "--prefix=${placeholder "out"}"
  ] ++ lib.optional enablePython "--enable-bindings-python";

  meta = with lib; {
    description = "C library and tools for interacting with the linux GPIO character device";
    longDescription = ''
      Since linux 4.8 the GPIO sysfs interface is deprecated. User space should use
      the character device instead. This library encapsulates the ioctl calls and
      data structures behind a straightforward API.
    '';
    homepage = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/about/";
    license = licenses.lgpl2;
    maintainers = [ maintainers.expipiplus1 ];
    platforms = platforms.linux;
  };
}
