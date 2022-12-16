{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, rocm-device-libs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clang-ocl";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "clang-ocl";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-uMSvcVJj+me2E+7FsXZ4l4hTcK6uKEegXpkHGcuist0=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  buildInputs = [ rocm-device-libs ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "OpenCL compilation with clang compiler";
    homepage = "https://github.com/RadeonOpenCompute/clang-ocl";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.version != stdenv.cc.cc.version;
  };
})
