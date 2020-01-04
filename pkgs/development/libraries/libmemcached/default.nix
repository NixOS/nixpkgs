{ stdenv, fetchurl, fetchpatch, cyrus_sasl, libevent }:

stdenv.mkDerivation {
  name = "libmemcached-1.0.18";

  src = fetchurl {
    url = https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz;
    sha256 = "10jzi14j32lpq0if0p9vygcl2c1352hwbywzvr9qzq7x6aq0nb72";
  };

  # Fix linking against libpthread (patch from Fedora)
  # https://bugzilla.redhat.com/show_bug.cgi?id=1037707
  # https://bugs.launchpad.net/libmemcached/+bug/1281907
  # Fix building on macOS (patch from Homebrew)
  # https://bugs.launchpad.net/libmemcached/+bug/1245562
  patches = stdenv.lib.optional stdenv.isLinux ./libmemcached-fix-linking-with-libpthread.patch
    ++ stdenv.lib.optional stdenv.isDarwin (fetchpatch {
      url = "https://raw.githubusercontent.com/Homebrew/homebrew/bfd4a0a4626b61c2511fdf573bcbbc6bbe86340e/Library/Formula/libmemcached.rb";
      sha256 = "1gjf3vd7hiyzxjvlg2zfc3y2j0lyr6nhbws4xb5dmin3csyp8qb8";
    })
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl ./musl-fixes.patch;

  buildInputs = [ libevent ];
  propagatedBuildInputs = [ cyrus_sasl ];

  NIX_CFLAGS_COMPILE = "-fpermissive";

  meta = with stdenv.lib; {
    homepage = https://libmemcached.org;
    description = "Open source C/C++ client library and tools for the memcached server";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
