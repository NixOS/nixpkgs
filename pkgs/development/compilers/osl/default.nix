{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  openexr,
  openimageio_2,
  llvmPackages_15,
  boost,
  flex,
  bison,
  partio,
  pugixml,
  util-linux,
  python3,
  qt6,
  robin-map,
  libxml2,
}:

let
  llvmPackages = llvmPackages_15;
  boost_static = boost.override { enableStatic = true; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "openshadinglanguage";
  version = "1.14.5.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenShadingLanguage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dmGVCx4m2bkeKhAJbU1mrzEDAmnL++7GA5okb9wwk/Y=";
  };

  cmakeFlags = [
    "-DBoost_ROOT=${boost}"
    "-DUSE_BOOST_WAVE=ON"
    "-DENABLE_RTTI=ON"

    # Build system implies llvm-config and llvm-as are in the same directory.
    # Override defaults.
    "-DLLVM_DIRECTORY=${llvmPackages.llvm}"
    "-DLLVM_CONFIG=${llvmPackages.llvm.dev}/bin/llvm-config"
    "-DLLVM_BC_GENERATOR=${llvmPackages.clang}/bin/clang++"

    # Set C++17 required for LLVM15+
    "-DCMAKE_CXX_STANDARD=17"
    "-DCLANG_LIBRARY_DIR=${llvmPackages.clang-unwrapped}/lib"
    "-DCLANG_LIBRARIES=clang-cpp"
  ];

  preConfigure = ''
    patchShebangs src/liboslexec/serialize-bc.bash
  '';

  nativeBuildInputs = [
    cmake
    bison
    flex
    llvmPackages.clang
    qt6.wrapQtAppsHook
  ];

  buildInputs =
    [
      boost_static
      llvmPackages.llvm
      llvmPackages.clang
      llvmPackages.libclang
      llvmPackages.clang-unwrapped
      openexr
      openimageio_2
      partio
      pugixml
      python3.pkgs.pybind11
      util-linux # needed just for hexdump
      zlib
      qt6.qtbase
      robin-map
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libxml2
    ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/*.pc \
      --replace-fail '=''${exec_prefix}//' '=/'
  '';

  meta = {
    description = "Advanced shading language for production GI renderers";
    homepage = "https://opensource.imageworks.com/osl.html";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.hodapp ];
    platforms = lib.platforms.unix;
  };
})
