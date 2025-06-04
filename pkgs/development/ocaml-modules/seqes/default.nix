{
  lib,
  fetchurl,
  buildDunePackage,
  qcheck,
  qcheck-alcotest,
  alcotest,
}:

buildDunePackage rec {
  pname = "seqes";
  version = "0.4";
  src = fetchurl {
    url = "https://gitlab.com/raphael-proust/seqes/-/archive/${version}/seqes-${version}.tar.gz";
    hash = "sha256-E4BalN68CJP7u6NSC0XBooWvUeSNqV+3KEOtoJ4g/dM=";
  };

  minimalOCamlVersion = "4.14";

  doCheck = true;
  checkInputs = [
    qcheck
    qcheck-alcotest
    alcotest
  ];

  meta = with lib; {
    description = "Variations of the Seq module with monads folded into the type";
    homepage = "https://gitlab.com/nomadic-labs/seqes";
    license = licenses.lgpl2; # Same as OCaml
    maintainers = [ maintainers.ulrikstrid ];
  };
}
