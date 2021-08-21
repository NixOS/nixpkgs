{ lib, stdenv, buildPackages
, gcc_src, version
, glibc
, autoreconfHook269, libiberty
}:

stdenv.mkDerivation rec {
  pname = "libatomic";
  inherit version;

  src = gcc_src;

  patches = [
    ../custom-threading-model.patch
  ];

  outputs = [ "out" "dev" ];

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook269 libiberty ];

  enableParallelBuilding = true;

  #postUnpack = ''
  #  mkdir -p ./build
  #  buildRoot=$(readlink -e "./build")
  #'';

  postPatch = ''
    sourceRoot=$(readlink -e "./libatomic")
  '';

  configurePlatforms = [ "build" "host" ];
  configureFlags = [
    "--disable-dependency-tracking"
    "--with-threads=single"
    # $CC cannot link binaries, let alone run then
    "cross_compiling=true"
    # Do not have dynamic linker without libc
    "--enable-static"
    "--disable-shared"
  ];

  makeFlags = [ "MULTIBUILDTOP:=../" ];

  postInstall = ''
    moveToOutput "lib/gcc/${stdenv.hostPlatform.config}/${version}/include" "$dev"
    mkdir -p "$out/lib" "$dev/include"
    ln -s "$out/lib/gcc/${stdenv.hostPlatform.config}/${version}"/* "$out/lib"
    ln -s "$dev/lib/gcc/${stdenv.hostPlatform.config}/${version}/include"/* "$dev/include/"
  '';
}
