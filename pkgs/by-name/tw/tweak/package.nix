{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "tweak";
  version = "3.02";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/tweak/${pname}-${version}.tar.gz";
    sha256 = "06js54pr5hwpwyxj77zs5s40n5aqvaw48dkj7rid2d47pyqijk2v";
  };

  buildInputs = [ ncurses ];
  preBuild = "substituteInPlace Makefile --replace '$(DESTDIR)/usr/local' $out";
  makeFlags = [
    "CC:=$(CC)"
    "LINK:=$(CC)"
  ];

<<<<<<< HEAD
  meta = {
    description = "Efficient hex editor";
    homepage = "http://www.chiark.greenend.org.uk/~sgtatham/tweak";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Efficient hex editor";
    homepage = "http://www.chiark.greenend.org.uk/~sgtatham/tweak";
    license = licenses.mit;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "tweak";
  };
}
