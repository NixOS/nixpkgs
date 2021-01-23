{ lib, stdenv, fetchFromGitHub, cmake, nasm
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {

  pname = "libjpeg-turbo";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "libjpeg-turbo";
    repo = "libjpeg-turbo";
    rev = version;
    sha256 = "0njdxfmyk8smj8bbd6fs3lxjaq3lybivwgg16gpnbiyl984dpi9b";
  };

  # This is needed by freeimage
  patches = [ ./0001-Compile-transupp.c-as-part-of-the-library.patch ]
    ++ lib.optional (stdenv.hostPlatform.libc or null == "msvcrt")
      ./mingw-boolean.patch;

  outputs = [ "bin" "dev" "dev_private" "out" "man" "doc" ];

  postFixup = ''
    moveToOutput include/transupp.h $dev_private
  '';

  nativeBuildInputs = [ cmake nasm ];

  cmakeFlags = [
    "-DENABLE_STATIC=${if enableStatic then "1" else "0"}"
    "-DENABLE_SHARED=${if enableShared then "1" else "0"}"
  ];

  doInstallCheck = true;
  installCheckTarget = "test";

  meta = with lib; {
    homepage = "https://libjpeg-turbo.org/";
    description = "A faster (using SIMD) libjpeg implementation";
    license = licenses.ijg; # and some parts under other BSD-style licenses
    maintainers = with maintainers; [ vcunat colemickens ];
    platforms = platforms.all;
  };
}
