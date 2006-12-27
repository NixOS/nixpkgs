{stdenv, fetchurl, x11, libXaw}:

stdenv.mkDerivation {
  name = "t1lib-5.1.0";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/t1lib-5.1.0.tar.gz;
    md5 = "a05bed4aa63637052e60690ccde70421";
  };
  buildInputs = [x11 libXaw];
  buildFlags = "without_doc";
}
