{ stdenv, fetchzip, ocaml, findlib, obuild }:

let version = "2.0.1"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ptmap-${version}";

  src = fetchzip {
    url = "https://github.com/UnixJunkie/ptmap/archive/v${version}.tar.gz";
    sha256 = "09ib4q5amkac2yy0hr7yn1n1j6y10v08chh82qc70wl7s473if15";
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
