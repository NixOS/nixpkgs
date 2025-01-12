{
  stdenv,
  lib,
  fetchFromGitHub,
  ocaml,
  findlib,
  camlp4,
  ocamlbuild,
  erm_xml,
  mirage-crypto,
  mirage-crypto-rng,
  base64,
  digestif,
}:

stdenv.mkDerivation rec {
  version = "0.3+20241009";
  pname = "ocaml${ocaml.version}-erm_xmpp";

  src = fetchFromGitHub {
    owner = "hannesm";
    repo = "xmpp";
    rev = "54418f77abf47b175e9c1b68a4f745a12b640d6a";
    sha256 = "sha256-AbzZjNkW1VH/FOnzNruvelZeo3IYg/Usr3enQEknTQs=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    camlp4
  ];
  buildInputs = [ camlp4 ];
  propagatedBuildInputs = [
    erm_xml
    mirage-crypto
    mirage-crypto-rng
    base64
    digestif
  ];

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure
    ocaml setup.ml -configure --prefix $out
    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild
    ocaml setup.ml -build
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    ocaml setup.ml -install
    runHook postInstall
  '';

  createFindlibDestdir = true;

  meta = {
    homepage = "https://github.com/hannesm/xmpp";
    description = "OCaml based XMPP implementation (fork)";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sternenseemann ];
    inherit (ocaml.meta) platforms;
  };
}
