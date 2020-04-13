{ stdenv, fetchurl, cmake, nasm, enableStatic ? false }:

stdenv.mkDerivation rec {

  pname = "libjpeg-turbo";
  version = "2.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "01ill8bgjyk582wipx7sh7gj2nidylpbzvwhx0wkcm6mxx3qbp9k";
  };

  patches =
    stdenv.lib.optional (stdenv.hostPlatform.libc or null == "msvcrt")
      ./mingw-boolean.patch;

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ cmake nasm ];

  cmakeFlags = [
    "-DENABLE_STATIC=${if enableStatic then "1" else "0"}"
  ];

  doInstallCheck = true;
  installCheckTarget = "test";

  meta = with stdenv.lib; {
    homepage = "http://libjpeg-turbo.virtualgl.org/";
    description = "A faster (using SIMD) libjpeg implementation";
    license = licenses.ijg; # and some parts under other BSD-style licenses
    maintainers = with maintainers; [ vcunat colemickens ];
    platforms = platforms.all;
  };
}
