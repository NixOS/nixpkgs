{ stdenv
, fetchurl, fetchpatch, autoreconfHook264, buildPackages, bison, binutils-raw
, libiberty, zlib
}:

stdenv.mkDerivation rec {
  name = "libbfd-${version}";
  inherit (binutils-raw.bintools) version src;

  outputs = [ "out" "dev" ];

  patches = binutils-raw.bintools.patches ++ [
    ../../tools/misc/binutils/build-components-separately.patch
    (fetchpatch {
      url = "https://raw.githubusercontent.com/mxe/mxe/e1d4c144ee1994f70f86cf7fd8168fe69bd629c6/src/bfd-1-disable-subdir-doc.patch";
      sha256 = "0pzb3i74d1r7lhjan376h59a7kirw15j7swwm8pz3zy9lkdqkj6q";
    })
  ];

  # We just want to build libbfd
  preConfigure = ''
    cd bfd
  '';

  depsBuildBuilds = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook264 bison ];
  buildInputs = [ libiberty zlib ];

  configurePlatforms = [ "build" "host" "target" ];
  configureFlags = [
    "--enable-targets=all" "--enable-64-bit-bfd"
    "--enable-install-libbfd"
    "--enable-shared"
    "--with-system-zlib"
    "CC_FOR_BUILD=$(CC)"
  ];

  postInstall = stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.targetPlatform) ''
    # the build system likes to move things into atypical locations
    mkdir -p $dev
    mv $out/${stdenv.hostPlatform.config}/${stdenv.targetPlatform.config}/include $dev/include
    mv $out/${stdenv.hostPlatform.config}/${stdenv.targetPlatform.config}/lib $out/lib
  '';

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
