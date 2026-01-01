{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.2pre4";

in

stdenv.mkDerivation {
  pname = "tivodecode";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/tivodecode/tivodecode/${version}/tivodecode-${version}.tar.gz";
    sha256 = "1pww5r2iygscqn20a1cz9xbfh18p84a6a5ifg4h5nvyn9b63k23q";
  };

<<<<<<< HEAD
  meta = {
    description = "Converts a .TiVo file (produced by TiVoToGo) to a normal MPEG file";
    homepage = "https://tivodecode.sourceforge.net";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Converts a .TiVo file (produced by TiVoToGo) to a normal MPEG file";
    homepage = "https://tivodecode.sourceforge.net";
    platforms = platforms.unix;
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
