{ stdenv, fetchurl, which, coq, ssreflect }:

let param =
  if stdenv.lib.versionAtLeast coq.coq-version "8.8"
  then {
    version = "3.1.0";
    uid = "38287";
    sha256 = "07436wkvnq9jyf7wyhp77bpl157s3qhba1ay5xrkxdi26qdf3h14";
  } else {
    version = "3.0.2";
    uid = "37523";
    sha256 = "1biia7nfqf7vaqq5gmykl4rwjyvrcwss6r2jdf0in5pvp2rnrj2w";
  }
; in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-coquelicot-${param.version}";
  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/${param.uid}/coquelicot-${param.version}.tar.gz";
    inherit (param) sha256;
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq ];
  propagatedBuildInputs = [ ssreflect ];

  configureFlags = [ "--libdir=$out/lib/coq/${coq.coq-version}/user-contrib/Coquelicot" ];
  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = {
    homepage = "http://coquelicot.saclay.inria.fr/";
    description = "A Coq library for Reals";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" "8.9" "8.10" "8.11" "8.12" ];
  };

}
