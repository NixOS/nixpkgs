{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  clang,
  libclang,
  libxml2,
  zlib,
  openexr,
  openimageio,
  llvm,
  boost,
  flex,
  bison,
  partio,
  pugixml,
  robin-map,
  util-linux,
  python3,
}:

let
  boost_static = boost.override { enableStatic = true; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openshadinglanguage";
  version = "1.14.7.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenShadingLanguage";
    rev = "v${finalAttrs.version}";
    hash = "sha256-w78x0e9T0lYCAPDPkx6T/4TzAs/mpJ/24uQ+yH5gB5I=";
  };

  cmakeFlags = [
    "-DBoost_ROOT=${boost}"
    "-DUSE_BOOST_WAVE=ON"
    "-DENABLE_RTTI=ON"

    # Build system implies llvm-config and llvm-as are in the same directory.
    # Override defaults.
    "-DLLVM_DIRECTORY=${llvm}"
    "-DLLVM_CONFIG=${llvm.dev}/bin/llvm-config"
    "-DLLVM_BC_GENERATOR=${clang}/bin/clang++"
  ];

  prePatch = ''
    substituteInPlace src/cmake/modules/FindLLVM.cmake \
      --replace-fail "NO_DEFAULT_PATH" ""
  '';

  preConfigure = ''
    patchShebangs src/liboslexec/serialize-bc.bash
  '';

  nativeBuildInputs = [
    bison
    clang
    cmake
    flex
  ];

  buildInputs = [
    boost_static
    libclang
    llvm
    openexr
    openimageio
    partio
    pugixml
    python3.pkgs.pybind11
    robin-map
    util-linux # needed just for hexdump
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libxml2
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/*.pc \
      --replace '=''${exec_prefix}//' '=/'
  '';

  meta = {
    description = "Advanced shading language for production GI renderers";
    homepage = "https://opensource.imageworks.com/osl.html";
    maintainers = with lib.maintainers; [ hodapp ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
