{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, clang
, hip
, rocm-device-libs
, rocprofiler
, libxml2
, doxygen
, graphviz
, gcc-unwrapped
, rocm-runtime
, python3Packages
, buildDocs ? false # Nothing seems to be generated, so not making the output
, buildTests ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "roctracer";
  version = "5.4.2";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ] ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "roctracer";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-5vYUNczylB2ehlvhq1u/H8KUXt8ku2E+jawKrKsU7LY=";
  };

  nativeBuildInputs = [
    cmake
    clang
    hip
  ] ++ lib.optionals buildDocs [
    doxygen
    graphviz
  ];

  buildInputs = [
    rocm-device-libs
    rocprofiler
    libxml2
    python3Packages.python
    python3Packages.cppheaderparser
  ];

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${hip}/hip/cmake"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  postPatch = ''
    export HIP_DEVICE_LIB_PATH=${rocm-device-libs}/amdgcn/bitcode
  '' + lib.optionalString (!buildTests) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(test)" ""
  '';

  # Tests always fail, probably need GPU
  # doCheck = buildTests;

  postInstall = lib.optionalString buildDocs ''
    mkdir -p $doc
  '' + lib.optionalString buildTests ''
    mkdir -p $test/bin
    # Not sure why this is an install target
    find $out/test -executable -type f -exec mv {} $test/bin \;
    rm $test/bin/{*.sh,*.py}
    patchelf --set-rpath $out/lib:${lib.makeLibraryPath (
      finalAttrs.buildInputs ++ [ hip gcc-unwrapped.lib rocm-runtime ])} $test/bin/*
    rm -rf $out/test
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Tracer callback/activity library";
    homepage = "https://github.com/ROCm-Developer-Tools/roctracer";
    license = with licenses; [ mit ]; # mitx11
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})
