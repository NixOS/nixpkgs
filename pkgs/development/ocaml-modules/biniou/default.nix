{ stdenv, fetchFromGitHub, ocaml, findlib, dune, easy-format }:

stdenv.mkDerivation rec {
  version = "1.2.0";
  name = "ocaml${ocaml.version}-biniou-${version}";
  src = fetchFromGitHub {
    owner = "mjambon";
    repo = "biniou";
    rev = "v${version}";
    sha256 = "0mjpgwyfq2b2izjw0flmlpvdjgqpq8shs89hxj1np2r50csr8dcb";
  };

  buildInputs = [ ocaml findlib dune ];

  propagatedBuildInputs = [ easy-format ];

  postPatch = ''
   patchShebangs .
  '';

  inherit (dune) installPhase;

  meta = {
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
    description = "Binary data format designed for speed, safety, ease of use and backward compatibility as protocols evolve";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.bsd3;
  };
}
