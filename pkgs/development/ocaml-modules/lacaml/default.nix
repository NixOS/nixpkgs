{ stdenv, fetchFromGitHub, darwin, ocaml, findlib, dune, base, stdio, lapack, blas }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.05.0";
assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-lacaml";
  version = "11.0.6";

  src = fetchFromGitHub {
    owner = "mmottl";
    repo = "lacaml";
    rev = version;
    sha256 = "1vn5441fg45d0ni9x87dhz2x4jrmvg3w7qk3vvcrd436snvh07g0";
  };

  buildInputs = [ ocaml findlib dune base stdio ];
  propagatedBuildInputs = [ lapack blas ] ++
    stdenv.lib.optionals stdenv.isDarwin
      [ darwin.apple_sdk.frameworks.Accelerate ];

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    homepage = "http://mmottl.github.io/lacaml";
    description = "OCaml bindings for BLAS and LAPACK";
    license = licenses.lgpl21Plus;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.rixed ];
  };
}
