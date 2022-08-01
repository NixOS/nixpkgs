{ lib, buildDunePackage, fetchFromGitHub, zlib, dune-configurator, zarith }:

buildDunePackage rec {
  pname = "cryptokit";
  version = "1.161";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "xavierleroy";
    repo = "cryptokit";
    rev = "release${lib.replaceStrings ["."] [""] version}";
    sha256 = "sha256-eDIzi16Al/mXCNos/lVqjZWCtdP9SllXnRfm4GBWMfA=";
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
