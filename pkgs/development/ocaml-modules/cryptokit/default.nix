{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  zlib,
  dune-configurator,
  zarith,
}:

buildDunePackage rec {
  pname = "cryptokit";
  version = "1.19";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "xavierleroy";
    repo = "cryptokit";
    rev = "release${lib.replaceStrings [ "." ] [ "" ] version}";
    hash = "sha256-8RRAPFgL2pqKotc1I3fIB9q2cNi46SP8pt+0rZM+QUc=";
  };

  # dont do autotools configuration, but do trigger findlib's preConfigure hook
  configurePhase = ''
    runHook preConfigure
    runHook postConfigure
  '';

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    zarith
    zlib
  ];

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
