{ stdenv, fetchFromGitHub, cmake, makeWrapper
, pkgconfig, libX11, libuuid, xz, vtk_7, Cocoa }:

stdenv.mkDerivation rec {
  pname = "itk";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "InsightSoftwareConsortium";
    repo = "ITK";
    rev = "v${version}";
    sha256 = "0db91pm1zy40h4qr5zsdfl94znk16w9ysddz5cxbl198iyyqii8f";
  };

  postPatch = ''
    substituteInPlace CMake/ITKSetStandardCompilerFlags.cmake  \
      --replace "-march=corei7" ""  \
      --replace "-mtune=native" ""
  '';

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DModule_ITKMINC=ON"
    "-DModule_ITKIOMINC=ON"
    "-DModule_ITKIOTransformMINC=ON"
    "-DModule_ITKVtkGlue=ON"
    "-DModule_ITKReview=ON"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake xz makeWrapper ];
  buildInputs = [ libX11 libuuid vtk_7 ] ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa ];

  postInstall = ''
    wrapProgram "$out/bin/h5c++" --prefix PATH ":" "${pkgconfig}/bin"
  '';

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = "https://www.itk.org/";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
