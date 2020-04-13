{ stdenv
, fetch
, cmake
, libxml2
, llvm
, version
}:

stdenv.mkDerivation {
  pname = "lld";
  inherit version;

  src = fetch "lld" "04afcfq2h7ysyqxxhyhb7ig4p0vdw7mi63kh8mffl74j0rc781p7";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvm libxml2 ];

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"
  '';

  meta = {
    description = "The LLVM Linker";
    homepage    = "https://lld.llvm.org/";
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };
}
