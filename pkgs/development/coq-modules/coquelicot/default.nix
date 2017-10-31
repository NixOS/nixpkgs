{ stdenv, fetchurl, which, coq, ssreflect }:

let param =
  let
  v2_1_1 = {
    version = "2.1.1";
    url = https://gforge.inria.fr/frs/download.php/file/35429/coquelicot-2.1.1.tar.gz;
    sha256 = "1wxds73h26q03r2xiw8shplh97rsbim2i2s0r7af0fa490bp44km";
  };
  v3_0_1 = {
    version = "3.0.1";
    url = "https://gforge.inria.fr/frs/download.php/file/37045/coquelicot-3.0.1.tar.gz";
    sha256 = "0hsyhsy2lwqxxx2r8xgi5csmirss42lp9bkb9yy35mnya0w78c8r";
  };
  in {
  "8.4" = v2_1_1;
  "8.5" = v3_0_1;
  "8.6" = v3_0_1;
  "8.7" = v3_0_1;
}."${coq.coq-version}"; in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-coquelicot-${param.version}";
  src = fetchurl { inherit (param) url sha256; };

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
