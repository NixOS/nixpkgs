args:
args.stdenv.mkDerivation {
  name = "faac-1.26";

  src = args.fetchurl {
    url = http://downloads.sourceforge.net/faac/faac-1.26.tar.gz;
    sha256 = "0ld9d8mn3yp90japzkqkicmjcggi7d8y9gn7cl1jdsb74bif4j2b";
  };

  preConfigure = "./bootstrap";

  buildInputs =(with args; [autoconf automake libtool]);

  meta = {
      description="open source MPEG-4 and MPEG-2 AAC encoder";
      homepage = http://www.audiocoding.com/faac.html;
      license = "LGPL";
  };
}
