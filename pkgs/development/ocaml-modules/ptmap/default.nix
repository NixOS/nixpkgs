{ stdenv, fetchzip, ocaml, findlib, obuild }:

let version = "2.0.3"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ptmap-${version}";

  src = fetchzip {
    url = "https://github.com/backtracking/ptmap/archive/v${version}.tar.gz";
    sha256 = "19xykhqk7q25r1pj8rpfj53j2r9ls8mxi1w5m2wqshrf20gf078h";
  };

  buildInputs = [ ocaml findlib obuild ];

  createFindlibDestdir = true;

  buildPhase = ''
    substituteInPlace ptmap.obuild --replace 'build-deps: qcheck' ""
    obuild configure
    obuild build lib-ptmap
  '';

  installPhase = ''
    obuild install --destdir $out/lib/ocaml/${ocaml.version}/site-lib
  '';

  meta = {
    homepage = https://www.lri.fr/~filliatr/software.en.html;
    platforms = ocaml.meta.platforms or [];
    description = "Maps over integers implemented as Patricia trees";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ volth ];
  };
}
