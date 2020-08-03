{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "inform6";
  version = "6.34-6.12.2";

  src = fetchurl  {
    url = "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-${version}.tar.gz";
    sha256 = "c149f143f2c29a4cb071e578afef8097647cc9e823f7fcfab518ac321d9d259f";
  };

  buildInputs = [ perl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Interactive fiction compiler and libraries";
    longDescription = ''
      Inform 6 is a C-like programming language for writing interactive fiction
      (text adventure) games.
    '';
    homepage = "https://gitlab.com/DavidGriffith/inform6unix";
    changelog = "https://gitlab.com/DavidGriffith/inform6unix/-/raw/${version}/NEWS";
    license = licenses.artistic2;
    maintainers = with stdenv.lib.maintainers; [ ddelabru ];
    platforms = platforms.all;
  };
}
