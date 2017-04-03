{ stdenv, fetchurl, pkgconfig }:

let baseName = "libart-lgpl"; in
with stdenv.lib;
stdenv.mkDerivation rec {

  name = "${baseName}-${version}";
  srcName = "${baseName}-R${version}";
  version = "${majorVer}.${minorVer}.${patchVer}";
  majorVer = "14";
  minorVer = "0";
  patchVer = "4";

  src = fetchurl {
    url = "mirror://tde/R${version}/dependencies/${srcName}.tar.bz2";
    sha256 = "0hz7zr8g5sc06f5ayz91rk4144sdn4m36vrpzv6gl05nq37q27d0";
  };

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = ''
    --enable-ansi
  '';

  preConfigure = ''
    cd ${baseName}
  '';

  meta = with stdenv.lib;{
    description = "A 2D drawing library";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
# Warning: autotool build, will be deprecated by cmake in the future
