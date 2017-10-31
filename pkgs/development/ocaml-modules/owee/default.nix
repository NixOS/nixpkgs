{ stdenv, fetchFromGitHub, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-owee-${version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "owee";
    rev = "v${version}";
    sha256 = "025a8sm03mm9qr7grdmdhzx7pyrd0dr7ndr5mbj5baalc0al132z";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  meta = {
    description = "An experimental OCaml library to work with DWARF format";
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
