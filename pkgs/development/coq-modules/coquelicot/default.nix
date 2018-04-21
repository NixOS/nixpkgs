{ stdenv, fetchurl, which, coq, ssreflect }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-coquelicot-3.0.1";
  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/37045/coquelicot-3.0.1.tar.gz";
    sha256 = "0hsyhsy2lwqxxx2r8xgi5csmirss42lp9bkb9yy35mnya0w78c8r";
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

  passthru = { inherit (ssreflect) compatibleCoqVersions; };

}
