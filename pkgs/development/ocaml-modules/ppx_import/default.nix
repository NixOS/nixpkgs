{stdenv, fetchFromGitHub, buildOcaml, opaline,
 cppo, ounit, ppx_deriving}:

buildOcaml rec {
  name = "ppx_import";

  version = "1.4";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_import";
    rev = "v${version}";
    sha256 = "14c2lp7r9080c4hsb1y1drbxxx3v44b7ib5wfh3kkh3f1jfsjwbk";
  };

  buildInputs = [ cppo ounit ppx_deriving opaline ];

  doCheck = true;
  checkTarget = "test";

  installPhase = "opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  meta = with stdenv.lib; {
    description = "A syntax extension that allows to pull in types or signatures from other compiled interface files";
    license = licenses.mit;
  };
}
