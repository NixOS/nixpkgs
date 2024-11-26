{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "memorymapping";
  version = "unstable-2014-02-20";

  src = fetchFromGitHub {
    owner = "NimbusKit";
    repo = "memorymapping";
    rev = "fc285afe13cb9d56a40c647b8ed6d6bd40636af7";
    sha256 = "sha256-9u/QvK9TDsKxcubINH2OAbx5fXXkKF0+YT7LoLDaF0M=";
  };

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    $CC -c src/fmemopen.c
    $AR rcs libmemorymapping.a fmemopen.o
    sed -e '1i#include <stdio.h>' -i src/fmemopen.h

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D libmemorymapping.a "$out"/lib/libmemorymapping.a
    install -D src/fmemopen.h "$out"/include/fmemopen.h

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://nimbuskit.github.io/memorymapping/";
    description = "fmemopen for Mac OS and iOS";
    license = licenses.asl20;
    maintainers = with maintainers; [ veprbl ];
    # Uses BSD-style funopen() to implement glibc-style fmemopen().
    # Add more BSDs if you need to.
    platforms = platforms.darwin;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
