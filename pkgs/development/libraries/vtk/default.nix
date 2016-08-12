{ stdenv, fetchurl, fetchpatch, cmake, mesa, libX11, xproto, libXt
, qtLib ? null }:

with stdenv.lib;

let
  os = stdenv.lib.optionalString;
  majorVersion = "7.0";
  minorVersion = "0";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "vtk-${os (qtLib != null) "qvtk-"}${version}";
  src = fetchurl {
    url = "${meta.homepage}files/release/${majorVersion}/VTK-${version}.tar.gz";
    sha256 = "1hrjxkcvs3ap0bdhk90vymz5pgvxmg7q6sz8ab3wsyddbshr1abq";
  };

  buildInputs = [ cmake mesa libX11 xproto libXt ]
    ++ optional (qtLib != null) qtLib;

  preBuild = ''
    export LD_LIBRARY_PATH="$(pwd)/lib";
  '';

  # Shared libraries don't work, because of rpath troubles with the current
  # nixpkgs camke approach. It wants to call a binary at build time, just
  # built and requiring one of the shared objects.
  # At least, we use -fPIC for other packages to be able to use this in shared
  # objects.
  cmakeFlags = [ "-DCMAKE_C_FLAGS=-fPIC" "-DCMAKE_CXX_FLAGS=-fPIC" ]
    ++ optional (qtLib != null) [ "-DVTK_USE_QT:BOOL=ON" ];

  enableParallelBuilding = true;

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = http://www.vtk.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ viric bbenoist ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
