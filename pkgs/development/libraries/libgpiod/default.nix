{ lib, stdenv, fetchurl, autoreconfHook, autoconf-archive, pkg-config, kmod
, enable-tools ? true
, enablePython ? false, python3, ncurses }:

stdenv.mkDerivation rec {
  pname = "libgpiod";
  version = "2.0.1";

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/snapshot/libgpiod-${version}.tar.gz";
    hash = "sha256-tu2lU1YWCo5zkG49SOlZ74EpZ4fXZJdbEPJX6WYGaOk=";
  };

  buildInputs = [ kmod ] ++ lib.optionals enablePython [ python3 ncurses ];
  nativeBuildInputs = [
    autoconf-archive
    pkg-config
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
