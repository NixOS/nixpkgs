{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  boost,
  curl,
  geos,
  libspatialite,
  luajit,
  prime-server,
  protobuf,
  python3,
  sqlite,
  zeromq,
  zlib,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valhalla";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "valhalla";
    repo = "valhalla";
    rev = finalAttrs.version;
    hash = "sha256-1X9vsWsgnzmXn7bCMhN2PNwtfV0RRdzRFZIrQN2PLfA=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix build
    (fetchpatch {
      url = "https://github.com/valhalla/valhalla/commit/e4845b68e8ef8de9eabb359b23bf34c879e21f2b.patch";
      hash = "sha256-xCufmXHGj1JxaMwm64JT9FPY+o0+x4glfJSYLdvHI8U=";
    })

    # Fix gcc-13 build:
    #   https://github.com/valhalla/valhalla/pull/4154
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/valhalla/valhalla/commit/ed93f30272377cc6803533a1bb94fe81d14af81c.patch";
      hash = "sha256-w4pnOqk/Jj3unVuesE64QSecrUIVSqwK69t9xNVc4GA=";
    })
  ];

  postPatch = ''
    substituteInPlace src/bindings/python/CMakeLists.txt \
      --replace "\''${Python_SITEARCH}" "${placeholder "out"}/${python3.sitePackages}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
    "-DENABLE_BENCHMARKS=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed for date submodule with GCC 12 https://github.com/HowardHinnant/date/issues/750
    "-Wno-error=stringop-overflow"
  ];

  buildInputs = [
    boost
    curl
    geos
    libspatialite
    luajit
    prime-server
    protobuf
    python3
    sqlite
    zeromq
    zlib
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/libvalhalla.pc \
      --replace '=''${prefix}//' '=/' \
      --replace '=''${exec_prefix}//' '=/'
  '';

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    changelog = "https://github.com/valhalla/valhalla/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Open Source Routing Engine for OpenStreetMap";
    homepage = "https://valhalla.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    pkgConfigModules = [ "libvalhalla" ];
    platforms = platforms.linux;
  };
})
