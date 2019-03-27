{ stdenv, fetchFromGitHub, darwin, ocaml, findlib, dune, base, stdio, liblapack, blas }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.05.0";

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-lacaml";
  version = "11.0.3";

  src = fetchFromGitHub {
    owner = "mmottl";
    repo = "lacaml";
    rev = version;
    sha256 = "1aflg07cc9ak9mg1cr0qr368c9s141glwlarl5nhalf6hhq7ibcb";
  };

  buildInputs = [ ocaml findlib dune base stdio ];
  propagatedBuildInputs = [ liblapack blas ] ++
    stdenv.lib.optionals stdenv.isDarwin
      [ darwin.apple_sdk.frameworks.Accelerate ];

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    homepage = http://mmottl.github.io/lacaml;
    description = "OCaml bindings for BLAS and LAPACK";
    license = licenses.lgpl21Plus;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.rixed ];
  };
}
