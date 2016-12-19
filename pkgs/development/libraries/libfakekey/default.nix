{ stdenv, fetchurl, libX11, libXi, libXtst, pkgconfig, xextproto }:

stdenv.mkDerivation rec {
  name = "libfakekey-${version}";
  version = "0.1";

  src = fetchurl {
    url = "http://downloads.yoctoproject.org/releases/matchbox/libfakekey/0.1/${name}.tar.gz";
    sha256 = "10msplyn535hmzbmbdnx4zc20hkaw6d81if5lzxs82k8sq2mkx9k";
  };

  buildInputs = [ libX11 libXi libXtst pkgconfig xextproto ];

  meta = with stdenv.lib; {
    description = "X virtual keyboard library";
    homepage = https://www.yoctoproject.org/tools-resources/projects/matchbox;
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
