{ stdenv, fetchzip, ocaml, findlib, obuild }:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.07"
  then {
    version = "2.0.4";
    sha256 = "05a391m1l04zigi6ghywj7f5kxy2w6186221k7711wmg56m94yjw";
  } else {
    version = "2.0.3";
    sha256 = "19xykhqk7q25r1pj8rpfj53j2r9ls8mxi1w5m2wqshrf20gf078h";
  }
; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ptmap-${param.version}";

  src = fetchzip {
    url = "https://github.com/backtracking/ptmap/archive/v${param.version}.tar.gz";
    inherit (param) sha256;
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
    homepage = "https://www.lri.fr/~filliatr/software.en.html";
    platforms = ocaml.meta.platforms or [];
    description = "Maps over integers implemented as Patricia trees";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ volth ];
  };
}
