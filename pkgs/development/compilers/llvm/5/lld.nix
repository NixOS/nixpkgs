{ stdenv
, fetch
, cmake
, llvm
, version
}:

stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch "lld" "1ah75rjly6747jk1zbwca3z0svr9b09ylgxd4x9ns721xir6sia6";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvm ];

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"
  '';

  meta = {
    description = "The LLVM Linker";
    homepage    = http://lld.llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
    badPlatforms = [ "x86_64-darwin" ];
  };
}
