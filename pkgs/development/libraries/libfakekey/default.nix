{ stdenv, fetchurl, libX11, libXi, libXtst, pkgconfig, xorgproto }:

stdenv.mkDerivation rec {
  pname = "libfakekey";
  version = "0.1";

  src = fetchurl {
    url = "https://downloads.yoctoproject.org/releases/matchbox/libfakekey/0.1/${pname}-${version}.tar.gz";
    sha256 = "10msplyn535hmzbmbdnx4zc20hkaw6d81if5lzxs82k8sq2mkx9k";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 libXi libXtst xorgproto ];
  NIX_LDFLAGS = "-lX11";

  meta = with stdenv.lib; {
    description = "X virtual keyboard library";
    homepage = https://www.yoctoproject.org/tools-resources/projects/matchbox;
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
