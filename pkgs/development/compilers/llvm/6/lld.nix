{ stdenv
, fetch
, cmake
, libxml2
, llvm
, python
, version
}:

stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch "lld" "16nzzi233kknb3sz0hvwypfp6wa1d6rc7izf0v5zzhgrcr86yy98";

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
    homepage    = http://lld.llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };
}
