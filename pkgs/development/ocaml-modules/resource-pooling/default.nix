{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, lwt_log }:

let pname = "resource-pooling"; in

if !stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "${pname} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.5.2";
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = pname;
    rev = version;
    sha256 = "00rz1i61w2dy108hzv38rblnsv6b56b5a1mk5h3zddpivcljp2dh";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ lwt_log ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase = "ocaml setup.ml -build";
  createFindlibDestdir = true;
  installPhase = "ocaml setup.ml -install";

  meta = {
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
    description = "A library for pooling resources like connections, threads, or similar";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
