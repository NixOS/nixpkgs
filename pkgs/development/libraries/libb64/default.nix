{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libb64";
  version = "2.0.0.1";

  src = fetchFromGitHub {
    owner = "libb64";
    repo = "libb64";
    rev = "v${version}";
    sha256 = "sha256-9loDftr769qnIi00MueO86kjha2EiG9pnCLogp0Iq3c=";
  };

  patches = [
    # Fix parallel build failure: https://github.com/libb64/libb64/pull/9
    #  make[1]: *** No rule to make target 'libb64.a', needed by 'c-example1'.  Stop.
    (fetchpatch {
      name = "parallel-make.patch";
      url = "https://github.com/libb64/libb64/commit/4fe47c052e9123da8f751545deb48be08c3411f6.patch";
      sha256 = "18b3np3gpyzimqmk6001riqv5n70wfbclky6zzsrvj5zl1dj4ljf";
    })
  ] ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) (fetchpatch {
    name = "0001-example-Do-not-run-the-tests.patch";
    url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-support/libb64/libb64/0001-example-Do-not-run-the-tests.patch?id=484e0de1e4ee107f21ae2a5c5f976ed987978baf";
    sha256 = "sha256-KTsiIWJe66BKlu/A43FWfW0XAu4E7lWX/RY4NITRrm4=";
  });

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out $out/lib $out/bin $out/include
    cp -r include/* $out/include/
    cp base64/base64 $out/bin/
    cp src/libb64.a src/cencode.o src/cdecode.o $out/lib/
  '';

  meta = {
    description = "ANSI C routines for fast base64 encoding/decoding";
    homepage = "https://github.com/libb64/libb64";
    license = lib.licenses.publicDomain;
    mainProgram = "base64";
    platforms = lib.platforms.unix;
  };
}
