{stdenv, fetchurl, x11, libXaw}:

stdenv.mkDerivation {
  name = "t1lib-5.1.0";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/metalab/libs/graphics/t1lib-5.1.0.tar.gz;
    md5 = "a05bed4aa63637052e60690ccde70421";
  };
  buildInputs = [x11 libXaw];
  buildFlags = "without_doc";
}
