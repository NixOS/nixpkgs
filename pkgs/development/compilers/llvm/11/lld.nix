{ stdenv
, fetch
, cmake
, libxml2
, llvm
, version
, buildOverride
}:

stdenv.mkDerivation rec {
  pname = "lld";
  inherit version;

  src = fetch pname "077xyh7sij6mhp4dc4kdcmp9whrpz332fa12rwxnzp3wgd5bxrzg";

  unpackPhase =
    if buildOverride == null then null
    else ''
      cp -r $src/lld/. .
      chmod -R u+w .
    '';

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
