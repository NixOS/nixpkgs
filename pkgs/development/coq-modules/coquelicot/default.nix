{ stdenv, fetchurl, which, coq, ssreflect }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-coquelicot-2.1.1";
  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/35429/coquelicot-2.1.1.tar.gz;
    sha256 = "1wxds73h26q03r2xiw8shplh97rsbim2i2s0r7af0fa490bp44km";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq ];
  propagatedBuildInputs = [ ssreflect ];

  configureFlags = "--libdir=$out/lib/coq/${coq.coq-version}/user-contrib/Coquelicot";
  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = {
    homepage = http://coquelicot.saclay.inria.fr/;
    description = "A Coq library for Reals";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };
}
