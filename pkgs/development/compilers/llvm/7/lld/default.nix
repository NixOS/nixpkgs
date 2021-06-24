{ lib, stdenv
, fetch
, cmake
, libxml2
, llvm
, version
}:

stdenv.mkDerivation {
  pname = "lld";
  inherit version;

  src = fetch "lld" "0rsqb7zcnij5r5ipfhr129j7skr5n9pyr388kjpqwh091952f3x1";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvm libxml2 ];

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
