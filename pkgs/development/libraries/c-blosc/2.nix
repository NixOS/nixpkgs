{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,

  static ? stdenv.hostPlatform.isStatic,

  lz4,
  zlib-ng,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "c-blosc2";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0eB+8zSlKCuHK1J2HlBUmWEJumAXSV2xnYMvnFud75A=";
  };

  # https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    sed -i -E \
      -e '/^libdir[=]/clibdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      -e '/^includedir[=]/cincludedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@' \
      blosc2.pc.in
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    lz4
    zlib-ng
    zstd
  ];

  cmakeFlags = [
    "-DBUILD_STATIC=${if static then "ON" else "OFF"}"
    "-DBUILD_SHARED=${if static then "OFF" else "ON"}"

    "-DPREFER_EXTERNAL_LZ4=ON"
    "-DPREFER_EXTERNAL_ZLIB=ON"
    "-DPREFER_EXTERNAL_ZSTD=ON"

    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_BENCHMARKS=OFF"
    "-DBUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
  ];

  doCheck = !static;
  # possibly https://github.com/Blosc/c-blosc2/issues/432
  enableParallelChecking = false;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "Blosc2" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Fast, compressed, persistent binary data store library for C";
    homepage = "https://www.blosc.org";
    changelog = "https://github.com/Blosc/c-blosc2/releases/tag/v${finalAttrs.version}";
    pkgConfigModules = [ "blosc2" ];
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ris ];
  };
})
