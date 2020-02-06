{ stdenv, fetchurl, which, coq, coquelicot, flocq, mathcomp
, bignums ? null }:

let params =
  if stdenv.lib.versionAtLeast coq.coq-version "8.7" then {
    version = "3.4.1";
    uid = "38104";
    sha256 = "1zklv2w34k866fpwmw8q692mid5n6s75d2mmhhigrzpx5l3d4z6y";
  } else {
    version = "3.3.0";
    uid = "37077";
    sha256 = "08fdcf3hbwqphglvwprvqzgkg0qbimpyhnqsgv3gac4y1ap0f903";
  }
; in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-interval-${params.version}";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/${params.uid}/interval-${params.version}.tar.gz";
    inherit (params) sha256;
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq ];
  propagatedBuildInputs = [ bignums coquelicot flocq ];

  configurePhase = "./configure --libdir=$out/lib/coq/${coq.coq-version}/user-contrib/Interval";
  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = with stdenv.lib; {
    homepage = http://coq-interval.gforge.inria.fr/;
    description = "Tactics for simplifying the proofs of inequalities on expressions of real numbers for the Coq proof assistant";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ vbgl ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" "8.9" "8.10" ];
  };


}
