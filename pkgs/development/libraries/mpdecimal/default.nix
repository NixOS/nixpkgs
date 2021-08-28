{ lib
, stdenv
, fetchurl
, windows
}:

stdenv.mkDerivation rec {
  pname = "mpdecimal";
  version = "2.5.1";

  src = fetchurl {
    url = "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-${version}.tar.gz";
    sha256 = "9f9cd4c041f99b5c49ffb7b59d9f12d95b683d88585608aa56a6307667b2b21f";
  };

  configurePlatforms = [ "build" "host" ];

  configureFlags = [
    # linking the shared objects with our binutils wrapper doesn't work
    # as flags end up getting passed which ld doesn't understand
    "LD=$(CC)"
  ];

  # need pthreads on windows
  buildInputs = lib.optional (stdenv.hostPlatform.libc == "msvcrt")
    (if stdenv.hostPlatform.is64bit
     then windows.mingw_w64_pthreads
     else windows.pthreads);

  # Link against libssp for __memcpy_chk on windows
  NIX_LDFLAGS = lib.optionalString (stdenv.hostPlatform.libc == "msvcrt") "-lssp";

  outputs = [ "out" "dev" "doc" ];

  meta = {
    description = "package for correctly-rounded arbitrary precision decimal floating point arithmetic";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://www.bytereef.org/mpdecimal/index.html";
  };
}
