{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "commoncpp2-1.8.0";

  src = fetchurl {
    url = "mirror://gnu/commoncpp/${name}.tar.gz";
    sha256 = "0a7arpm9l3s5qics5m77lyx1yl7998lkypydqwx11nj730034nmc";
  };

  doCheck = true;

  meta = {
    description = "GNU Common C++, a portable, highly optimized C++ class framework";

    longDescription =
      '' GNU Common C++ and GNU uCommon are very portable and highly
         optimized class framework for writing C++ applications that need to
         use threads and support concurrent sychronization, and that use
         sockets, XML parsing, object serialization, thread-optimized String
         and data structure classes, etc.  This framework offers a class
         foundation that hides platform differences from your C++ application
         so that you need not write platform specific code.  GNU Common C++
         has been ported to compile nativily on most platforms which support
         either posix threads, or on maybe be used with Debian hosted mingw32
         to build native threading applications for Microsoft Windows.
      '';

    homepage = http://www.gnu.org/software/commoncpp/;
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.marcweber
                    stdenv.lib.maintainers.ludo
                  ];
    platforms = stdenv.lib.platforms.all;
  };
}
