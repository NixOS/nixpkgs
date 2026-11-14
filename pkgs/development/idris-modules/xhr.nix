{
  build-idris-package,
  fetchFromGitHub,
  idrisscript,
  lib,
}:
build-idris-package {
  pname = "xhr";
  version = "2017-04-22";

  idrisDeps = [ idrisscript ];

  src = fetchFromGitHub {
    owner = "pierrebeaucamp";
    repo = "idris-xhr";
    rev = "fb32a748ccdb9070de3f2d6048564e34c064b362";
    hash = "sha256-2Tpv+89sw/oIT6yW31XgkmaCu3+4iwV462TlnZWtB1A=";
  };

  meta = {
    description = "Idris library to interact with xhr";
    homepage = "https://github.com/pierrebeaucamp/idris-xhr";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
