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

  src = fetch pname "044lv1d9am2xmbc3pvssxkkiyxyv72n2xkgk8z3p9k72h3ay00q3";

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
