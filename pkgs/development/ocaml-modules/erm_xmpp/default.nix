{ stdenv, lib, fetchFromGitHub, ocaml, findlib, camlp4, ocamlbuild
, erm_xml, mirage-crypto, mirage-crypto-rng, base64
}:

stdenv.mkDerivation rec {
  version = "0.3+20200317";
  pname = "ocaml${ocaml.version}-erm_xmpp";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "xmpp";
    rev    = "7fa5bea252671fd88625c6af109998b879ca564f";
    sha256 = "0spzyd9kbyizzwl8y3mq8z19zlkzxnkh2fppry4lyc7vaw7bqrwq";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild camlp4 ];
  buildInputs = [ camlp4 ];
  propagatedBuildInputs = [ erm_xml mirage-crypto mirage-crypto-rng base64 ];

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
