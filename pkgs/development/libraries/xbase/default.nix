{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "xbase-3.1.2";

  src = fetchurl {
    url = mirror://sourceforge/xdb/xbase64-3.1.2.tar.gz;
    sha256 = "17287kz1nmmm64y7zp9nhhl7slzlba09h6cc83w4mvsqwd9w882r";
  };

  prePatch = "find . -type f -not -name configure -print0 | xargs -0 chmod -x";
  patches = [ ./xbase-fixes.patch ];

  meta = {
    homepage = http://linux.techass.com/projects/xdb/;
    description = "XBase compatible C++ class library formerly known as XDB";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
