{ stdenv, fetchurl, fetchpatch, ocaml, findlib, piqi, camlp4 }:

stdenv.mkDerivation rec {
  version = "0.7.5";
  name    = "piqi-ocaml-${version}";

  src = fetchurl {
    url = "https://github.com/alavrik/piqi-ocaml/archive/v${version}.tar.gz";
    sha256 = "0ngz6y8i98i5v2ma8nk6mc83pdsmf2z0ks7m3xi6clfg3zqbddrv";
  };

  patches = [ (fetchpatch {
    url = https://github.com/alavrik/piqi-ocaml/commit/336e8fdb84e77f4105e9bbb5ab545b8729101308.patch;
    sha256 = "071s4xjyr6xx95v6az2lbl2igc87n7z5jqnnbhfq2pidrxakd0la";
  })];

  buildInputs = [ ocaml findlib piqi camlp4 ];

  createFindlibDestdir = true;

  installPhase = "DESTDIR=$out make install";

  meta = with stdenv.lib; {
    homepage = http://piqi.org;
    description = "Universal schema language and a collection of tools built around it. These are the ocaml bindings";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer ];
  };
}
