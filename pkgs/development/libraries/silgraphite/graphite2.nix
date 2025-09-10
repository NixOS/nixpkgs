{
  lib,
  stdenv,
  llvmPackages,
  fetchurl,
  pkg-config,
  freetype,
  cmake,
  static ? stdenv.hostPlatform.isStatic,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.3.14";
  pname = "graphite2";

  src = fetchurl {
    url =
      with finalAttrs;
      "https://github.com/silnrsi/graphite/releases/download/${version}/${pname}-${version}.tgz";
    sha256 = "1790ajyhk0ax8xxamnrk176gc9gvhadzy78qia4rd8jzm89ir7gr";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    freetype
  ]
  ++ lib.optional (stdenv.targetPlatform.useLLVM or false) (
    llvmPackages.compiler-rt.override {
      doFakeLibgcc = true;
    }
  );

  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./macosx.patch ];
  postPatch = ''
    # disable broken 'nametabletest' test, fails on gcc-13:
    #   https://github.com/silnrsi/graphite/pull/74
    substituteInPlace tests/CMakeLists.txt \
      --replace 'add_subdirectory(nametabletest)' '#add_subdirectory(nametabletest)'

    # support cross-compilation by using target readelf binary:
    substituteInPlace Graphite.cmake \
      --replace 'readelf' "${stdenv.cc.targetPrefix}readelf"

    # headers are located in the dev output:
    substituteInPlace CMakeLists.txt \
      --replace-fail ' ''${CMAKE_INSTALL_PREFIX}/include' " ${placeholder "dev"}/include"
  '';

  cmakeFlags = lib.optionals static [
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  # Remove a test that fails to statically link (undefined reference to png and
  # freetype symbols)
  postConfigure = lib.optionalString static ''
    sed -e '/freetype freetype.c/d' -i ../tests/examples/CMakeLists.txt
  '';

  doCheck = true;

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Advanced font engine";
    homepage = "https://graphite.sil.org/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.raskin ];
    pkgConfigModules = [ "graphite2" ];
    mainProgram = "gr2fonttest";
    platforms = platforms.unix ++ platforms.windows;
  };
})
