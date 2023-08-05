{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

let
  opencvVer = "4.6.0";
  patchVer = "16";

  opencvSrc = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv";
    rev = opencvVer;
    hash = "sha256-zPkMc6xEDZU5TlBH3LAzvB17XgocSPeHVMG/U6kfpxg=";
  };

  patchSrc = fetchFromGitHub {
    owner = "nihui";
    repo = "opencv-mobile";
    rev = "v${patchVer}";
    hash = "sha256-ijt3EoezUr9Pnh0FFHL7y1Or/ec63sgKds1p4Ob5Tcc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencv-mobile";
  version = "${opencvVer}-${patchVer}";

  src = opencvSrc;

  nativeBuildInputs = [
    cmake
  ];

  outputs = [ "out" "dev" ];

  postPatch = ''
    patch -p1 -i ${patchSrc}/opencv-4.6.0-no-zlib.patch
    truncate -s 0 cmake/OpenCVFindLibsGrfmt.cmake
    rm -rf modules/gapi
    rm -rf modules/highgui
    cp -r ${patchSrc}/highgui modules/
    chmod +w modules/highgui
    patch -p1 -i ${patchSrc}/opencv-4.6.0-no-rtti.patch
  '';

  preConfigure = ''
    cmakeFlags="`cat ${patchSrc}/opencv4_cmake_options.txt` $cmakeFlags"
  '';

  cmakeFlags = [
    "-DBUILD_opencv_world=OFF"
  ];

  meta = {
    description = "The minimal opencv for Android, iOS, ARM Linux, Windows, Linux, MacOS, WebAssembly";
    homepage = "https://github.com/nihui/opencv-mobile";
    license = with lib.licenses; [ bsd3 asl20 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rewine ];
  };
})
