{ lib, stdenv, buildPackages, fetchFromGitHub, autoconf, automake, libtool, pkgconfig,
  zlib, ilmbase, fetchpatch }:

let
  # Doesn't really do anything when not crosscompiling
  emulator = stdenv.hostPlatform.emulator buildPackages;
in

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "020gyl8zv83ag6gbcchmqiyx9rh2jca7j8n52zx1gk4rck7kwc01";
  };

  sourceRoot = "source/OpenEXR";

  outputs = [ "bin" "dev" "out" "doc" ];

  # Needed because there are some generated sources. Solution: just run them under QEMU.
  postPatch = ''
    for file in b44ExpLogTable dwaLookups
    do
      # Ecape for both sh and Automake
      emu=${lib.escapeShellArg (lib.replaceStrings ["$"] ["$$"] emulator)}
      before="./$file > $file.h"
      after="$emu $before"
      substituteInPlace IlmImf/Makefile.am \
        --replace "$before" "$after"
    done

    # Make sure the patch succeeded
    [[ $(grep "$emu" IlmImf/Makefile.am | wc -l) = 2 ]]
  '';

  preConfigure = ''
    patchShebangs ./bootstrap
    ./bootstrap
  '';

  # otherwise, the pkgconfig info for the libraries will not match the filenames
  configureFlags = stdenv.lib.optionalString stdenv.isDarwin "--enable-namespaceversioning=no";

  nativeBuildInputs = [ pkgconfig autoconf automake libtool ];
  propagatedBuildInputs = [ ilmbase zlib ];

  enableParallelBuilding = true;
  doCheck = false; # fails 1 of 1 tests

  meta = with stdenv.lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
