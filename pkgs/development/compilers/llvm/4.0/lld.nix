{ stdenv
, fetch
, cmake
, zlib
, llvm
, python
, version
}:

stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch "lld" "144vmb13800s33xgd18321lrviw21mjx5dphzszjgvizn4a1sf1p";

  buildInputs = [ cmake llvm ];

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
