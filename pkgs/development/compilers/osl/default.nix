{ stdenv, clangStdenv, lib, fetchFromGitHub, cmake, zlib, openexr,
openimageio, llvm, boost165, flex, bison, partio, pugixml,
util-linux, python3
}:

let boost_static = boost165.override { enableStatic = true; };
in clangStdenv.mkDerivation rec {
  # In theory this could use GCC + Clang rather than just Clang,
  # but https://github.com/NixOS/nixpkgs/issues/29877 stops this
  pname = "openshadinglanguage";
  version = "1.10.9";

  src = fetchFromGitHub {
    owner = "imageworks";
    repo = "OpenShadingLanguage";
    rev = "Release-1.10.9";
    sha256 = "1dwf10f2fpxc55pymwkapql20nc462mq61hv21c527994c2qp1ll";
  };

  cmakeFlags = [
    "-DUSE_BOOST_WAVE=ON"
    "-DENABLERTTI=ON"

    # Build system implies llvm-config and llvm-as are in the same directory.
    # Override defaults.
    "-DLLVM_DIRECTORY=${llvm}"
    "-DLLVM_CONFIG=${llvm.dev}/bin/llvm-config"
  ];

  preConfigure = "patchShebangs src/liboslexec/serialize-bc.bash ";

  nativeBuildInputs = [ cmake boost_static flex bison];
  buildInputs = [
     zlib openexr openimageio llvm
     partio pugixml
     util-linux # needed just for hexdump
     python3 # CMake doesn't check this?
  ];
  # TODO: How important is partio? CMake doesn't seem to find it
  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Advanced shading language for production GI renderers";
    homepage = "http://opensource.imageworks.com/?p=osl";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
