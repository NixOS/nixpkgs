{ stdenv, fetchurl, autoconf, automake, libtool, libxml2, cppunit, boost
, apr, aprutil, db45, expat
}:

stdenv.mkDerivation {
  name = "log4cxx-0.10.0";
  
  src = fetchurl {
    url = http://apache.mirrors.hoobly.com/logging/log4cxx/0.10.0/apache-log4cxx-0.10.0.tar.gz;    
    sha256 = "130cjafck1jlqv92mxbn47yhxd2ccwwnprk605c6lmm941i3kq0d";
  };
  
  buildInputs = [autoconf automake libtool libxml2 cppunit boost apr aprutil db45 expat];

  meta = {
    homepage = http://logging.apache.org/log4cxx/index.html;
    description = "A logging framework for C++ patterned after Apache log4j";
  };
}
