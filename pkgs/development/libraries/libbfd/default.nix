{ stdenv
, fetchurl, autoreconfHook264, bison, binutils-raw
, libiberty, zlib
}:

stdenv.mkDerivation rec {
  name = "libbfd-${version}";
  inherit (binutils-raw) version src;

  outputs = [ "out" "dev" ];

  patches = binutils-raw.patches ++ [
    ../../tools/misc/binutils/build-components-separately.patch
  ];

  # We just want to build libbfd
  postPatch = ''
    cd bfd
  '';

  nativeBuildInputs = [ autoreconfHook264 bison ];
  buildInputs = [ libiberty zlib ];

  configurePlatforms = [ "build" "host" ];
  configureFlags = [
    "--enable-targets=all" "--enable-64-bit-bfd"
    "--enable-install-libbfd"
    "--enable-shared"
    "--with-system-zlib"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library for manipulating containers of machine code";
    longDescription = ''
      BFD is a library which provides a single interface to read and write
      object files, executables, archive files, and core files in any format.
      It is associated with GNU Binutils, and elsewhere often distributed with
      it.
    '';
    homepage = http://www.gnu.org/software/binutils/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericson2314 ];
    platforms = platforms.unix;
  };
}
