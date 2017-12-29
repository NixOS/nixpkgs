{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, topkg, opam, jbuilder
, cmdliner, astring, fmt, result
}:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02" then {
    version = "0.8.1";
    sha256 = "1bjhgwmshlaz9xncrrkknys7prigf8vlg1kqvfx9l8kn92mlf10b";
    buildInputs = [ jbuilder ];
    buildPhase = "jbuilder build -p alcotest";
    inherit (jbuilder) installPhase;
  } else {
    version = "0.7.2";
    sha256 = "1qgsz2zz5ky6s5pf3j3shc4fjc36rqnjflk8x0wl1fcpvvkr52md";
    buildInputs = [ ocamlbuild opam topkg ];
    inherit (topkg) buildPhase installPhase;
  };
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-alcotest-${version}";
  inherit (param) version buildPhase installPhase;

  src = fetchzip {
    url = "https://github.com/mirage/alcotest/archive/${version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ] ++ param.buildInputs;

  propagatedBuildInputs = [ cmdliner astring fmt result ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/alcotest;
    description = "A lightweight and colourful test framework";
    license = stdenv.lib.licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
