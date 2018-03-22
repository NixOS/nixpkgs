{ stdenv, buildPackages
, fetchurl, fetchpatch, gnu-config, autoreconfHook264, bison
, libiberty, zlib
}:

let inherit (buildPackages.buildPackages) binutils-raw; in

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
  postPatch = ''
    cd bfd
  '';

  postAutoreconf = ''
    echo "Updating config.guess and config.sub from ${gnu-config}"
    cp -f ${gnu-config}/config.{guess,sub} ../
  '';

  # We update these ourselves
  dontUpdateAutotoolsGnuConfigScripts = true;

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
