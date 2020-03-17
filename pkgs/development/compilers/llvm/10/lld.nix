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

  src = fetch pname "1c8s5jcp1h2lvws6dxy7c3a36ic10q6lbmd4i38l3g3irl6dj871";

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
