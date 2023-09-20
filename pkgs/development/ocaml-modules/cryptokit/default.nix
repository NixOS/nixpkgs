{ lib, buildDunePackage, fetchFromGitHub, zlib, dune-configurator, zarith }:

buildDunePackage rec {
  pname = "cryptokit";
  version = "1.18";
  duneVersion = "3";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "xavierleroy";
    repo = "cryptokit";
    rev = "release${lib.replaceStrings ["."] [""] version}";
    hash = "sha256-8ae8hroCSkp4O5vM/qVOhAnnJJ+uygMYm3ix5ytwtHU=";
  };

  # dont do autotools configuration, but do trigger findlib's preConfigure hook
  configurePhase = ''
    runHook preConfigure
    runHook postConfigure
  '';

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ zarith zlib ];

  doCheck = true;

  meta = {
    homepage = "http://pauillac.inria.fr/~xleroy/software.html";
    description = "A library of cryptographic primitives for OCaml";
    license = lib.licenses.lgpl2Only;
    maintainers = [
      lib.maintainers.maggesi
    ];
  };
}
