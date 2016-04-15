{ stdenv, fetchurl, fetchpatch, cmake, mesa, libX11, xproto, libXt
, qtLib ? null
# Darwin support
, Cocoa, CoreServices, DiskArbitration, IOKit, CFNetwork, Security, GLUT
, ApplicationServices, CoreText, IOSurface, cf-private, ImageIO, xpc, libobjc }:

with stdenv.lib;
let
  os = stdenv.lib.optionalString;
  majorVersion = "5.10";
  minorVersion = "1";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "vtk-${os (qtLib != null) "qvtk-"}${version}";
  src = fetchurl {
    url = "${meta.homepage}files/release/${majorVersion}/vtk-${version}.tar.gz";
    sha256 = "1fxxgsa7967gdphkl07lbfr6dcbq9a72z5kynlklxn7hyp0l18pi";
  };

  # https://bugzilla.redhat.com/show_bug.cgi?id=1138466
  postPatch = "sed '/^#define GL_GLEXT_LEGACY/d' -i ./Rendering/vtkOpenGL.h";

  buildInputs =
    if !stdenv.isDarwin
    then [ cmake mesa libX11 xproto libXt ] ++ optional (qtLib != null) qtLib
    else [ cmake qtLib xpc CoreServices DiskArbitration IOKit
           CFNetwork Security ApplicationServices CoreText IOSurface ImageIO
           GLUT ];
  propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ Cocoa libobjc ];

  # Shared libraries don't work, because of rpath troubles with the current
  # nixpkgs camke approach. It wants to call a binary at build time, just
  # built and requiring one of the shared objects.
  # At least, we use -fPIC for other packages to be able to use this in shared
  # objects.
  cmakeFlags = [ "-DCMAKE_C_FLAGS=-fPIC" "-DCMAKE_CXX_FLAGS=-fPIC" ]
    ++ optional (qtLib != null) [ "-DVTK_USE_QT:BOOL=ON" ]
    ++ optional stdenv.isDarwin [ "-DBUILD_TESTING:BOOL=OFF" ];

  postConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's, -F/Applications/Xcode.app/.*\.sdk/System/Library/Frameworks,,' Rendering/CMakeFiles/vtkRendering.dir/flags.make
    sed -i 's/#define inline//' ../Utilities/vtktiff/tif_config.h.in
  '';

  doCheck = !stdenv.isDarwin;

  enableParallelBuilding = true;

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = http://www.vtk.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ viric bbenoist ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
