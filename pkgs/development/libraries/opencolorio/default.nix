{ stdenv, fetchurl, cmake, unzip }:

stdenv.mkDerivation rec {
  name = "ocio-${version}";
  version = "1.0.8";

  src = fetchurl {
    url = "https://github.com/imageworks/OpenColorIO/archive/v1.0.8.zip";
    sha256 = "1l70bf40dz2znm9rh3r6xs9d6kp719y1djayb7dc89khfqqbx2di";
  };

  buildInputs = [ cmake unzip ];

  meta = with stdenv.lib; {
    homepage = http://opencolorio.org;
    description = "A color management framework for visual effects and animation";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}