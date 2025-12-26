{
  stdenv,
  lib,
  fetchFromGitHub,
  ocaml,
  findlib,
  astring,
  pprint,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocp-ocamlres";
  version = "0.4";
  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-ocamlres";
    rev = "v${version}";
    sha256 = "0smfwrj8qhzknhzawygxi0vgl2af4vyi652fkma59rzjpvscqrnn";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];
  buildInputs = [
    astring
    pprint
  ];

  strictDeps = true;

  createFindlibDestdir = true;

  installFlags = [ "BINDIR=$(out)/bin" ];
  preInstall = "mkdir -p $out/bin";

  meta = {
    description = "Simple tool and library to embed files and directories inside OCaml executables";
    homepage = "https://www.typerex.org/ocp-ocamlres.html";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "ocp-ocamlres";
    inherit (ocaml.meta) platforms;
    broken = lib.versionOlder ocaml.version "4.02";
  };
}
