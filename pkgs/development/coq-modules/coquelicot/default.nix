{ stdenv, fetchurl, which, coq, ssreflect }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-coquelicot-3.0.2";
  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/37523/coquelicot-3.0.2.tar.gz";
    sha256 = "1biia7nfqf7vaqq5gmykl4rwjyvrcwss6r2jdf0in5pvp2rnrj2w";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq ];
  propagatedBuildInputs = [ ssreflect ];

  configureFlags = [ "--libdir=$out/lib/coq/${coq.coq-version}/user-contrib/Coquelicot" ];
  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = {
    homepage = http://coquelicot.saclay.inria.fr/;
    description = "A Coq library for Reals";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" "8.9" ];
  };

}
