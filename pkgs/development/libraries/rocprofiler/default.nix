{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-runtime
, rocm-thunk
, roctracer
, numactl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocprofiler";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "rocprofiler";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-CpD/+soMN8WTeSb5X7dsnZ596PMkw+4EVsVSvFtKCak=";
  };

  patches = [ ./0000-dont-require-hsa_amd_aqlprofile.patch ];
  nativeBuildInputs = [ cmake ];

  buildInputs = [
    rocm-thunk
    rocm-runtime
    numactl
  ];

  cmakeFlags = [
    "-DPROF_API_HEADER_PATH=${roctracer.src}/inc/ext"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  postPatch = ''
    patchShebangs bin test

    substituteInPlace cmake_modules/env.cmake \
      --replace "FATAL_ERROR \"AQL_PROFILE" "WARNING \"AQL_PROFILE"
  '';

  postInstall = ''
    patchelf --set-rpath $out/lib:${lib.makeLibraryPath finalAttrs.buildInputs} $out/lib/rocprofiler/librocprof-tool.so
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Profiling with perf-counters and derived metrics";
    homepage = "https://github.com/ROCm-Developer-Tools/rocprofiler";
    license = with licenses; [ mit ]; # mitx11
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
