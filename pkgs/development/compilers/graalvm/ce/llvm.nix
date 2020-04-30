# This file contains a patched and precompiled
# llvm suite for graal-sulong
{ stdenv, lib, fetchurl, glibc_multi, zlib }:

let llvm-compiler-rt = fetchurl {
  url = "https://lafo.ssw.uni-linz.ac.at/pub/llvm-org/compiler-rt-llvmorg-9.0.0-4-g9cf46c329d-bgf06552bd84-linux-amd64.tar.gz";
  sha256 = "1y4shcmdn8ychisgml0mshjs4rwd5pbsb179bqj73hdv1v5qsdy1";
};

in stdenv.mkDerivation rec {
  version = "9.0.0-4";
  pname = "llvm-sulong";
  src = fetchurl {
    url = "https://lafo.ssw.uni-linz.ac.at/pub/llvm-org/llvm-llvmorg-9.0.0-4-g9cf46c329d-bgf06552bd84-linux-amd64.tar.gz";
    sha256 = "1r0xki4c17dc36iyy3v2cndbws06hn0l3mg4pphw4hajrjx0almd";
  };
  sourceRoot = ".";

  buildPhase = ''
    find ./bin -type f -executable -exec patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${lib.makeLibraryPath [ zlib stdenv.cc.cc.lib (placeholder "out")]} '{}' \;
    patchelf --set-rpath ${lib.makeLibraryPath [ zlib stdenv.cc.cc.lib (placeholder "out")]} lib/*.so*
  '';

  installPhase = ''
    mkdir -p $out

    # Should contain just one lib dir
    tar -xf ${llvm-compiler-rt} -C $out

    cp -r bin $out
    cp -r include $out
    cp -rf ${glibc_multi.out}/lib/* $out/lib
    cp -rf lib/* $out/lib
    cp -r ${stdenv.cc.bintools.libc.dev}/* $out
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    # Make sure that the binaries can run
    $out/bin/clang -help > /dev/null
    $out/bin/opt -help > /dev/null

    # libc headers from stdenv needs to be bundled too
    stat $out/include/stdlib.h > /dev/null
    stat $out/include/stdio.h > /dev/null
  '';
  dontStrip = true;
}
