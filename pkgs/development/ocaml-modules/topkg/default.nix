{ stdenv, fetchurl, ocaml, findlib, result, opam }:

let ocaml-version = stdenv.lib.getVersion ocaml; in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml-version}-topkg-${version}";
  version = "0.7.8";

  src = fetchurl {
    url = "http://erratique.ch/software/topkg/releases/topkg-${version}.tbz";
    sha256 = "029lbmabczpmcgkj53mc20vmpcn3f7rf7xms4xf0nywswfzsash6";
  };

  nativeBuildInputs = [ opam ];
  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ result ];

  unpackCmd = "tar xjf ${src}";
  buildPhase = "ocaml -I ${findlib}/lib/ocaml/${ocaml-version}/site-lib/ pkg/pkg.ml build";
  createFindlibDestdir = true;
  installPhase = ''
    opam-installer --script --prefix=$out topkg.install | sh
    mv $out/lib/topkg $out/lib/ocaml/${ocaml-version}/site-lib/
  '';

  meta = {
    homepage = http://erratique.ch/software/topkg;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    description = "A packager for distributing OCaml software";
    inherit (ocaml.meta) platforms;
  };
}
