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

  src = fetch "lld" "00km1qawk146pyjqa6aphcdzgkzrmg6cgk0ikg4661ffp5bn9q1k";

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
