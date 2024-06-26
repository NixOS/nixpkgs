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
}:

stdenv.mkDerivation rec {
  version = "0.3+20220404";
  pname = "ocaml${ocaml.version}-erm_xmpp";

  src = fetchFromGitHub {
    owner = "hannesm";
    repo = "xmpp";
    rev = "e54d54e142ac9770c37e144693473692bf473530";
    sha256 = "sha256-Ize8Em4LI54Cy1Xuzr9BjQGV7JMr3W6KI1YzI8G1q/U=";
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
