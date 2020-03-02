{ stdenv, fetchurl, autoreconfHook, autoconf-archive, pkgconfig, kmod, enable-tools ? true }:

stdenv.mkDerivation rec {
  pname = "libgpiod";
  version = "1.5";

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/snapshot/libgpiod-${version}.tar.gz";
    sha256 = "1r337ici2nvi9v2h33nf3b7nisirc4s8p31cpv1cg8jbzn3wi15g";
  };

  buildInputs = [ kmod ];
  nativeBuildInputs = [
    autoconf-archive
    pkgconfig
    autoreconfHook
  ];

  configureFlags = [
    "--enable-tools=${if enable-tools then "yes" else "no"}"
    "--enable-bindings-cxx"
    "--prefix=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
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
