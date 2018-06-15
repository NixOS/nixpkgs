{ stdenv, fetchzip, autoconf, automake, libtool, libpcap }:

stdenv.mkDerivation rec {
  name = "libcrafter-${version}";
  version = "0.3";

  src = fetchzip {
    url = "https://github.com/pellegre/libcrafter/archive/version-${version}.zip";
    sha256 = "04lpmshh4wb1dav03p6rnskpd1zmmvhv80xwn8v7l8faps5gvjp4";
  };

  preConfigure = "cd libcrafter";

  configureScript = "./autogen.sh";

  configureFlags = [ "--with-libpcap=yes" ];

  buildInputs = [ autoconf automake libtool ];

  propagatedBuildInputs = [ libpcap ];

  meta = {
    homepage = https://github.com/pellegre/libcrafter;
    description = "High level C++ network packet sniffing and crafting library";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.lethalman ];
    platforms = stdenv.lib.platforms.unix;
  };
}
