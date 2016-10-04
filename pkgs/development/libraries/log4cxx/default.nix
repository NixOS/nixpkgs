{ stdenv, fetchurl, autoconf, automake, libtool, libxml2, cppunit, boost
, apr, aprutil, db, expat
}:

stdenv.mkDerivation rec {
  name = "log4cxx-${version}";
  version = "0.10.0";

  src = fetchurl {
    url = "http://apache.mirrors.hoobly.com/logging/log4cxx/${version}/apache-${name}.tar.gz";
    sha256 = "130cjafck1jlqv92mxbn47yhxd2ccwwnprk605c6lmm941i3kq0d";
  };

  postPatch = ''
    sed -i -e '1,/^#include/ {
      /^#include/i \
        #include <cstdio> \
        #include <cstdlib> \
        #include <cstring>
    }' src/examples/cpp/console.cpp \
       src/main/cpp/inputstreamreader.cpp \
       src/main/cpp/socketoutputstream.cpp
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
  sed -i 's/namespace std { class locale; }/#include <locale>/' src/main/include/log4cxx/helpers/simpledateformat.h
  sed -i 's/\(#include <cctype>\)/\1\n#include <cstdlib>/' src/main/cpp/stringhelper.cpp
  '';

  buildInputs = [autoconf automake libtool libxml2 cppunit boost apr aprutil db expat];

  meta = {
    homepage = http://logging.apache.org/log4cxx/index.html;
    description = "A logging framework for C++ patterned after Apache log4j";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
