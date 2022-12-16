{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, pkg-config
, cmake
, rocm-cmake
, libdrm
, numactl
, valgrind
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-thunk";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCT-Thunk-Interface";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-EU5toaKzVeZpdm/YhaQ0bXq0eoYwYQ5qGLUJzxgZVjE=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    rocm-cmake
  ];

  buildInputs = [
    libdrm
    numactl
    valgrind
  ];

  cmakeFlags = [
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Radeon open compute thunk interface";
    homepage = "https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface";
    license = with licenses; [ bsd2 mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    broken = finalAttrs.version != stdenv.cc.version;
  };
})
