{ stdenv
, lib
, fetchFromGitHub
, cmake
, clang
, libclang
, zlib
, openexr
, openimageio
, llvm
, boost
, flex
, bison
, partio
, pugixml
, util-linux
, python3
}:

let

  boost_static = boost.override { enableStatic = true; };

in stdenv.mkDerivation rec {
  pname = "openshadinglanguage";
  version = "1.12.11.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenShadingLanguage";
    rev = "v${version}";
    hash = "sha256-kN0+dWOUPXK8+xtR7onuPNimdn8WcaKcSRkOnaoi7BQ=";
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

    # Set C++11 to C++14 required for LLVM10+
    "-DCMAKE_CXX_STANDARD=14"
  ];

  preConfigure = "patchShebangs src/liboslexec/serialize-bc.bash ";

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
    util-linux # needed just for hexdump
    zlib
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/*.pc \
      --replace '=''${exec_prefix}//' '=/'
  '';

  meta = with lib; {
    description = "Advanced shading language for production GI renderers";
    homepage = "https://opensource.imageworks.com/osl.html";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
