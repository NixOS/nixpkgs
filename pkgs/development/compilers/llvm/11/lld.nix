{ stdenv
, fetch
, cmake
, libxml2
, llvm
, version
}:

stdenv.mkDerivation rec {
  pname = "lld";
  inherit version;

  src = fetch pname "056r8xjcs45mf9njnzjw6fmdbmagwpy13wk7xlf6sqhx5ap7wgr4";

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
