{ stdenv, cmake, pkgconfig, libpng, libtiff, lcms2, glib/*passthru only*/
, sharedLibsSupport ? true # Build shared libraries
, codecSupport ? true # Codec executables
, mj2Support ? true # MJ2 executables
, jpwlLibSupport ? true # JPWL library & executables
, jpipLibSupport ? true # JPIP library & executables
, jpipServerSupport ? false, curl ? null, fcgi ? null # JPIP Server
#, opjViewerSupport ? false, wxGTK ? null # OPJViewer executable
, openjpegJarSupport ? false, jdk ? null # Openjpeg jar (Java)
, jp3dSupport ? true # # JP3D comp
, thirdPartySupport ? false # Third party libraries - OFF: only build when found, ON: always build
, testsSupport ? false
# Inherit generics
, branch, src, version, ...
}:

assert jpipServerSupport -> (jpipLibSupport && (curl != null) && (fcgi != null));
#assert opjViewerSupport -> (wxGTK != null);
assert openjpegJarSupport -> (jdk != null);
assert testsSupport -> codecSupport;

let
  mkFlag = optSet: flag: if optSet then "-D${flag}=ON" else "-D${flag}=OFF";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "openjpeg-${version}";
  inherit branch;
  inherit version;
  inherit src;

  cmakeFlags = [
    (mkFlag sharedLibsSupport "BUILD_SHARED_LIBS")
    (mkFlag codecSupport "BUILD_CODEC")
    (mkFlag mj2Support "BUILD_MJ2")
    (mkFlag jpwlLibSupport "BUILD_JPWL")
    (mkFlag jpipLibSupport "BUILD_JPIP")
    (mkFlag jpipServerSupport "BUILD_JPIP_SERVER")
    #(mkFlag opjViewerSupport "BUILD_VIEWER")
    (mkFlag openjpegJarSupport "BUILD_JAVA")
    (mkFlag jp3dSupport "BUILD_JP3D")
    (mkFlag thirdPartySupport "BUILD_THIRDPARTY")
    (mkFlag testsSupport "BUILD_TESTING")
  ];

  nativebuildInputs = [ pkgconfig ];

  buildInputs = [ cmake ]
    ++ optionals jpipServerSupport [ curl fcgi ]
    #++ optional opjViewerSupport wxGTK
    ++ optional openjpegJarSupport jdk;

  propagatedBuildInputs = [ libpng libtiff lcms2 ];

  postInstall = glib.flattenInclude + ''
    mkdir -p "$out/lib/pkgconfig"
    cat > "$out/lib/pkgconfig/libopenjp2.pc" <<EOF
    prefix=$out
    libdir=$out/lib
    includedir=$out/include

    Name: openjp2
    Description: JPEG2000 library (Part 1 and 2)
    URL: http://www.openjpeg.org/
    Version: @OPENJPEG_VERSION@
    Libs: -L$out/lib -lopenjp2
    Cflags: -I$out/include
    EOF
  '';

  passthru = {
    incDir = "openjpeg-${branch}";
  };

  meta = {
    description = "Open-source JPEG 2000 codec written in C language";
    homepage    = http://www.openjpeg.org/;
    license     = licenses.bsd2;
    maintainer  = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
