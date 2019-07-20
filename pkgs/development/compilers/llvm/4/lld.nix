{ stdenv
, fetch
, cmake
, llvm
, version
}:

stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch "lld" "1v9nkpr158j4yd4zmi6rpnfxkp78r1fapr8wji9s6v176gji1kk3";

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
