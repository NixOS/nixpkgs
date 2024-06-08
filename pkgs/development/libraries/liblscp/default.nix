{ lib, stdenv, fetchurl, autoconf, automake, libtool, pkg-config }:

stdenv.mkDerivation rec {
  pname = "liblscp";
  version = "0.9.4";

  src = fetchurl {
    url = "https://download.linuxsampler.org/packages/${pname}-${version}.tar.gz";
    sha256 = "sha256-8+3qHgIv32wfNHHggXID1W8M7pTqji4bHNGob3DTkho=";
  };

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  preConfigure = "make -f Makefile.git";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.linuxsampler.org";
    description = "LinuxSampler Control Protocol (LSCP) wrapper library";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
