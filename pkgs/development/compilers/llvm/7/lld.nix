{ stdenv
, fetch
, cmake
, libxml2
, llvm
, version
}:

stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch "lld" "10p8yqikpsx1hvs524dj6fk7hg267bhs6860xngk33130s9s05id";

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
