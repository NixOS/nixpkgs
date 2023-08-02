{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, gfortran
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipfort";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "hipfort";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-x1pF9md7RIcobE/4UxHxOaURbljFZGOashW1KM0lmo0=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    gfortran
  ];

  cmakeFlags = [
    "-DHIPFORT_COMPILER=${gfortran}/bin/gfortran"
    "-DHIPFORT_AR=${gfortran.cc}/bin/gcc-ar"
    "-DHIPFORT_RANLIB=${gfortran.cc}/bin/gcc-ranlib"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  postPatch = ''
    patchShebangs bin

    substituteInPlace bin/hipfc bin/mymcpu \
      --replace "/bin/cat" "cat"

    substituteInPlace bin/CMakeLists.txt \
      --replace "/bin/mkdir" "mkdir" \
      --replace "/bin/cp" "cp" \
      --replace "/bin/sed" "sed" \
      --replace "/bin/chmod" "chmod" \
      --replace "/bin/ln" "ln"
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Fortran interfaces for ROCm libraries";
    homepage = "https://github.com/ROCmSoftwarePlatform/hipfort";
    license = with licenses; [ mit ]; # mitx11
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
