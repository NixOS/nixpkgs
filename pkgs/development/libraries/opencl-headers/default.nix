{ lib
, stdenv
, fetchFromGitHub
, cmake
, hashcat
, ocl-icd
, tesseract
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencl-headers";
  version = "2023.12.14";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-wF9KQjzYKJf6ulXRy80o53bp6lTtm8q1NubKbcH+RY0=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.tests = {
    inherit ocl-icd tesseract hashcat;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "OpenCL-Headers" ];
    };
  };

  meta = with lib; {
    description = "Khronos OpenCL headers version ${finalAttrs.version}";
    homepage = "https://www.khronos.org/registry/cl/";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = [ ];
  };
})
