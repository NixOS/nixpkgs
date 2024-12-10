{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libantlr3c";
  version = "3.4";
  src = fetchurl {
    url = "https://www.antlr3.org/download/C/libantlr3c-${version}.tar.gz";
    sha256 = "0lpbnb4dq4azmsvlhp6khq1gy42kyqyjv8gww74g5lm2y6blm4fa";
  };

  configureFlags =
    lib.optional stdenv.is64bit "--enable-64bit"
    # libantlr3c wrongly emits the abi flags -m64 and -m32 which imply x86 archs
    # https://github.com/antlr/antlr3/issues/205
    ++ lib.optional (!stdenv.hostPlatform.isx86) "--disable-abiflags";

  meta = with lib; {
    description = "C runtime libraries of ANTLR v3";
    homepage = "https://www.antlr3.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vbgl ];
  };
}
