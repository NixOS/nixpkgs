{ lib, stdenv, fetchFromGitHub, ocaml, findlib }:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.03.0";

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-syslog";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "rixed";
    repo = "ocaml-syslog";
    rev = "v${version}";
    sha256 = "1kqpc55ppzv9n555qgqpda49n7nvkqimzisyjx2a7338r7q4r5bw";
  };

  nativeBuildInputs = [ ocaml findlib ];
  strictDeps = true;

  buildFlags = [ "all" "opt" ];

  createFindlibDestdir = true;

  meta = with lib; {
    homepage = "https://github.com/rixed/ocaml-syslog";
    description = "Simple wrapper to access the system logger from OCaml";
    license = licenses.lgpl21Plus;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.rixed ];
  };
}
