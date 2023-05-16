{ stdenv
, lib
, fetchFromGitHub
, cmake
, clang
, libclang
<<<<<<< HEAD
, libxml2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "1.12.13.0";
=======
  version = "1.12.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenShadingLanguage";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-EVV7YHovWwbRju+uv8IK2wpcpoK1ndZ8yNRHzU8LUuE=";
=======
    hash = "sha256-kxfDhqF8uTdLqt99rTOk8TWBdN5NF7zm98CT0DbLrW0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isDarwin [
    libxml2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    platforms = platforms.unix;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
