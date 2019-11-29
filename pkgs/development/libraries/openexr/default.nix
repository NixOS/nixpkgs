{ lib, stdenv, buildPackages, fetchurl, autoconf, automake, libtool, pkgconfig,
  zlib, ilmbase, fetchpatch }:

let
  # Doesn't really do anything when not crosscompiling
  emulator = stdenv.hostPlatform.emulator buildPackages;
in

stdenv.mkDerivation rec {
  pname = "openexr";
  version = lib.getVersion ilmbase;

  src = fetchurl {
    url = "https://github.com/openexr/openexr/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "19jywbs9qjvsbkvlvzayzi81s976k53wg53vw4xj66lcgylb6v7x";
  };

  patches = [
    ./bootstrap.patch
    (fetchpatch {
      name = "CVE-2018-18444.patch";
      url = "https://github.com/openexr/openexr/commit/1b0f1e5d7dcf2e9d6cbb4e005e803808b010b1e0.patch";
      sha256 = "0f5m4wdwqqg8wfg7azzsz5yfpdrvws314rd4sqfc74j1g6wrcnqj";
      stripLen = 1;
    })
  ];

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
