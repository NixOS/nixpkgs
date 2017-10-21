{stdenv, fetchFromGitHub, buildOcaml, ocaml, opam,
 cppo, ppx_tools, ounit, ppx_deriving}:

buildOcaml rec {
  name = "ppx_import";

  version = "1.1";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "ppx_import";
    rev = "v${version}";
    sha256 = "1hfvbc81dg58q7kkpn808b3j0xazrqfrr4v71sd1yvmnk71wak6k";
  };

  buildInputs = [ cppo ounit ppx_deriving opam ];

  doCheck = true;
  checkTarget = "test";

  installPhase = ''
    opam-installer --script --prefix=$out ppx_import.install | sh
    ln -s $out/lib/ppx_import $out/lib/ocaml/${ocaml.version}/site-lib
  '';

  meta = with stdenv.lib; {
    description = "A syntax extension that allows to pull in types or signatures from other compiled interface files";
    license = licenses.mit;
  };
}