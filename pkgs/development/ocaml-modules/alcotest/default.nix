{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, topkg, dune
, cmdliner, astring, fmt, result
}:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02" then {
    version = "0.8.2";
    sha256 = "1zpg079v89mz2dpnh59f9hk5r03wl26skfn43llrv3kg24abjfpf";
    buildInputs = [ dune ];
    buildPhase = "dune build -p alcotest";
    inherit (dune) installPhase;
  } else {
    version = "0.7.2";
    sha256 = "1qgsz2zz5ky6s5pf3j3shc4fjc36rqnjflk8x0wl1fcpvvkr52md";
    buildInputs = [ ocamlbuild topkg ];
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
