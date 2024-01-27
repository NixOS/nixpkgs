{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "inform6";
  version = "6.41-r11";

  src = fetchurl  {
    url = "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-${version}.tar.gz";
    sha256 = "sha256-kfFfjJL03f3af1h/JdvkItuDFu8aGlM3BRa2eBB+ddY=";
  };

  buildInputs = [ perl ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Interactive fiction compiler and libraries";
    longDescription = ''
      Inform 6 is a C-like programming language for writing interactive fiction
      (text adventure) games.
    '';
    homepage = "https://gitlab.com/DavidGriffith/inform6unix";
    changelog = "https://gitlab.com/DavidGriffith/inform6unix/-/raw/${version}/NEWS";
    license = licenses.artistic2;
    maintainers = with lib.maintainers; [ ddelabru ];
    platforms = platforms.all;
  };
}
