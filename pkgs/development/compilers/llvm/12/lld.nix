{ lib, stdenv
, fetch
, libunwind
, cmake
, libxml2
, llvm
, version
}:

stdenv.mkDerivation rec {
  pname = "lld";
  inherit version;

  src = fetch pname "0r9pxhvinipirv9s5k8fnsnqd30zfniwqjkvw5sac3lq29rn2lp1";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvm libxml2 ];

  postPatch = ''
    substituteInPlace MachO/CMakeLists.txt --replace \
      '(''${LLVM_MAIN_SRC_DIR}/' '('
    mkdir -p libunwind/include
    tar -xf "${libunwind.src}" --wildcards -C libunwind/include --strip-components=2 "libunwind-*/include/"
  '';

  outputs = [ "out" "dev" ];

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"
  '';

  meta = {
    description = "The LLVM Linker";
    homepage    = "https://lld.llvm.org/";
    license     = lib.licenses.ncsa;
    platforms   = lib.platforms.all;
  };
}
