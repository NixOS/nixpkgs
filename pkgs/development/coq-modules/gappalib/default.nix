{ stdenv, fetchurl, which, coq, flocq }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-gappalib-1.4.1";
  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/37917/gappalib-coq-1.4.1.tar.gz;
    sha256 = "0d3f23a871haglg8hq1jgxz3y5nryiwy12b5xfnfjn279jfqqjw4";
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
    homepage = http://gappa.gforge.inria.fr/;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = stdenv.lib.flip builtins.elem [ "8.7" "8.8" "8.9" ];
  };

}
