{ stdenv, fetchurl, autoconf, automake, libtool, libX11, xorgproto
, libXi, libXaw, libXmu, libXt }:

let
  majorVersion = "1";
  minorVersion = "3";
in

stdenv.mkDerivation rec {
  name = "ois-${version}";
  version = "${majorVersion}.${minorVersion}";

  src = fetchurl {
    url = "mirror://sourceforge/project/wgois/Source%20Release/${version}/ois_v${majorVersion}-${minorVersion}.tar.gz";
    sha256 = "18gs6xxhbqb91x2gm95hh1pmakimqim1k9c65h7ah6g14zc7dyjh";
  };

  patches = [
    (fetchurl {
      url = http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/dev-games/ois/files/ois-1.3-gcc47.patch;
      sha256 = "026jw06n42bcrmg0sbdhzc4cqxsnf7fw30a2z9cigd9x282zhii8";
      name = "gcc47.patch";
    })
  ];

  patchFlags = "-p0";

  buildInputs = [
    autoconf automake libtool libX11 xorgproto libXi libXaw
    libXmu libXt
  ];

  preConfigure = "sh bootstrap";

  meta = with stdenv.lib; {
    description = "Object-oriented C++ input system";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.zlib;
  };
}
