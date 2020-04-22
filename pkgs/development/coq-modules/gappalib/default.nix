{ stdenv, fetchurl, which, coq, flocq }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-gappalib-1.4.3";
  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/38302/gappalib-coq-1.4.3.tar.gz";
    sha256 = "108k9dks04wbcqz38pf0zz11hz5imbzimpnkgjrk5gp1hifih370";
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
    compatibleCoqVersions = stdenv.lib.flip builtins.elem [ "8.8" "8.9" "8.10" "8.11" ];
  };

}
