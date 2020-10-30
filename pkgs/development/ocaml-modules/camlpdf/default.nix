{ stdenv, fetchFromGitHub, which, ocaml, findlib }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "camlpdf is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "2.3.1";
  name = "ocaml${ocaml.version}-camlpdf-${version}";
  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "camlpdf";
    rev = "v${version}";
    sha256 = "1q69hhk63z836jbkv4wsng27w35w0qpz01c7ax0mqm8d8kmnr0v4";
  };

  buildInputs = [ which ocaml findlib ];

  # Version number in META file is wrong
  patchPhase = ''
    patch -p 0 META <<EOF
    3c3
    < version="1.7.1"
    ---
    > version="${version}"
    EOF
  '';

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';

  meta = with stdenv.lib; {
    description = "An OCaml library for reading, writing and modifying PDF files";
    homepage = "https://github.com/johnwhitington/camlpdf";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [vbgl];
  };
}
