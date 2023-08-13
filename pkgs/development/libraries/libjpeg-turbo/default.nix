{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, nasm
, openjdk
, enableJava ? false # whether to build the java wrapper
, enableJpeg7 ? false # whether to build libjpeg with v7 compatibility
, enableJpeg8 ? false # whether to build libjpeg with v8 compatibility
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !stdenv.hostPlatform.isStatic

# for passthru.tests
, dvgrab
, epeg
, freeimage
, gd
, graphicsmagick
, imagemagick
, imlib2
, jhead
, libjxl
, mjpegtools
, opencv
, python3
, vips
}:

assert !(enableJpeg7 && enableJpeg8);  # pick only one or none, not both

stdenv.mkDerivation rec {

  pname = "libjpeg-turbo";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "libjpeg-turbo";
    repo = "libjpeg-turbo";
    rev = version;
    hash = "sha256-B4NCpL4whM5+fuW/U1bdRVnpnELA63Cx5dtbmGGM/YU=";
  };

  patches = [
    (fetchpatch {
      name = "fix-test-concurrency-issue.patch";
      url = "https://github.com/libjpeg-turbo/libjpeg-turbo/commit/035ea386d1b6a99a8a1e2ab57cc1fc903569136c.patch";
      hash = "sha256-xPo6hshbj+diRpL3CPY1lntYXjEVSsN2Vd3bSS8rV3c=";
    })
    # This is needed by freeimage
    ./0001-Compile-transupp.c-as-part-of-the-library.patch
  ] ++ lib.optional (stdenv.hostPlatform.libc or null == "msvcrt")
    ./mingw-boolean.patch;

  outputs = [ "bin" "dev" "dev_private" "out" "man" "doc" ];

  postFixup = ''
    moveToOutput include/transupp.h $dev_private
  '';

  nativeBuildInputs = [
    cmake
    nasm
  ] ++ lib.optionals enableJava [
    openjdk
  ];

  cmakeFlags = [
    "-DENABLE_STATIC=${if enableStatic then "1" else "0"}"
    "-DENABLE_SHARED=${if enableShared then "1" else "0"}"
  ] ++ lib.optionals enableJava [
    "-DWITH_JAVA=1"
  ] ++ lib.optionals enableJpeg7 [
    "-DWITH_JPEG7=1"
  ] ++ lib.optionals enableJpeg8 [
    "-DWITH_JPEG8=1"
  ] ++ lib.optionals stdenv.hostPlatform.isRiscV [
    # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/428
    # https://github.com/libjpeg-turbo/libjpeg-turbo/commit/88bf1d16786c74f76f2e4f6ec2873d092f577c75
    "-DFLOATTEST=fp-contract"
  ];

  doInstallCheck = true;
  installCheckTarget = "test";

  passthru.tests = {
    inherit
      dvgrab
      epeg
      freeimage
      gd
      graphicsmagick
      imagemagick
      imlib2
      jhead
      libjxl
      mjpegtools
      opencv
      vips;
    inherit (python3.pkgs) pillow imread pyturbojpeg;
  };

  meta = with lib; {
    homepage = "https://libjpeg-turbo.org/";
    description = "A faster (using SIMD) libjpeg implementation";
    license = licenses.ijg; # and some parts under other BSD-style licenses
    maintainers = with maintainers; [ vcunat colemickens kamadorueda ];
    platforms = platforms.all;
  };
}
