{ stdenv, fetchFromGitHub, ocaml, findlib, owee }:

if !stdenv.lib.versionAtLeast ocaml.version "4.04"
then throw "spacetime_lib is not available for OCaml ${ocaml.version}" else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-spacetime_lib-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "lpw25";
    repo = "spacetime_lib";
    rev = version;
    sha256 = "1g91y6wl3z18jhaz2q03wn54zj6xk1qcjidr1nc6nq9a8906lcq5";
  };

  buildInputs = [ ocaml findlib ];

  propagatedBuildInputs = [ owee ];

  createFindlibDestdir = true;

  meta = {
    description = "An OCaml library providing some simple operations for handling OCaml “spacetime” profiles";
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
