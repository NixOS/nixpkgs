{ stdenv, fetchurl, which, coq, flocq }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-gappalib-1.4.4";
  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/38338/gappalib-coq-1.4.4.tar.gz";
    sha256 = "1ds9qp3ml07w5ali0rsczlwgdx4xcgasgbcnpi2lssgj1xpxgfpn";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq coq.ocamlPackages.ocaml ];
  propagatedBuildInputs = [ flocq ];

  configurePhase = "./configure --libdir=$out/lib/coq/${coq.coq-version}/user-contrib/Gappa";
  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = {
    description = "Coq support library for Gappa";
    license = stdenv.lib.licenses.lgpl21;
    homepage = "http://gappa.gforge.inria.fr/";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = stdenv.lib.flip builtins.elem [ "8.8" "8.9" "8.10" "8.11" "8.12" ];
  };

}
