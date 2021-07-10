{ clangStdenv, lib, fetchFromGitHub, cmake, zlib, openexr,
openimageio2, llvmPackages, boost165, flex, bison, partio, pugixml,
util-linux, python3
}:

let boost_static = boost165.override { enableStatic = true; };
in clangStdenv.mkDerivation rec {
  # In theory this could use GCC + Clang rather than just Clang,
  # but https://github.com/NixOS/nixpkgs/issues/29877 stops this
  pname = "openshadinglanguage";
  version = "1.11.14.2";

  src = fetchFromGitHub {
    owner = "imageworks";
    repo = "OpenShadingLanguage";
    rev = "Release-${version}";
    sha256 = "1giy847b981jv2vlcl6ra5c5clrqsv26ma7qr4w6sagjxly0wxi5";
  };

  cmakeFlags = [ "-DUSE_BOOST_WAVE=ON" "-DENABLERTTI=ON" ];

  preConfigure = ''
    patchShebangs src/liboslexec/serialize-bc.bash

    # Remove fixed llvm path (which is autodetected as llvm.dev...)
    sed 's,[$]{LLVM_DIRECTORY}/bin/,,' -i src/liboslexec/CMakeLists.txt src/cmake/cuda_macros.cmake
  '';

  nativeBuildInputs = [
    cmake boost_static flex bison
    python3.pkgs.pybind11
  ];
  buildInputs = [
    zlib openexr openimageio2
    llvmPackages.llvm llvmPackages.clang-unwrapped
     partio pugixml
     util-linux # needed just for hexdump
     python3 # CMake doesn't check this?
  ];
  # TODO: How important is partio? CMake doesn't seem to find it

  meta = with lib; {
    description = "Advanced shading language for production GI renderers";
    homepage = "http://opensource.imageworks.com/?p=osl";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
