{stdenv, fetchurl, x11, libXaw, libXpm}:

stdenv.mkDerivation {
  name = "t1lib-5.1.0";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/metalab/libs/graphics/t1lib-5.1.1.tar.gz;
    sha256 = "0r1wb94kjd8jwym9na2k2snikizrnyc4cf4mf92v89r4yy0apph8";
  };
  buildInputs = [x11 libXaw libXpm];
  buildFlags = "without_doc";
}

