{ lib, fetchFromGitHub, buildDunePackage, ocaml, cppo, ppx_tools, ppx_deriving
, ppxfind }:

if lib.versionAtLeast ocaml.version "4.11"
then throw "ppx_deriving_protobuf is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "ppx_deriving_protobuf";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aq4f3gbkhhai0c8i5mcw2kpqy8l610f4dknwkrxh0nsizwbwryn";
  };

  buildInputs = [ cppo ppx_tools ppxfind ppx_deriving ];

  meta = with lib; {
    homepage = "https://github.com/ocaml-ppx/ppx_deriving_protobuf";
    description = "A Protocol Buffers codec generator for OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
