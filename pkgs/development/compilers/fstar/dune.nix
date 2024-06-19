{ batteries
, buildDunePackage
, memtrace
, menhir
, menhirLib
, pprint
, ppx_deriving
, ppx_deriving_yojson
, ppxlib
, process
, sedlex
, src
, stdint
, version
, yojson
, zarith
}:

buildDunePackage {
  pname = "fstar";
  inherit version src;

  postPatch = ''
    patchShebangs ocaml/fstar-lib/make_fstar_version.sh
    cd ocaml
  '';

  nativeBuildInputs = [
    menhir
  ];

  buildInputs = [
    memtrace
  ];

  propagatedBuildInputs = [
    batteries
    menhirLib
    pprint
    ppx_deriving
    ppx_deriving_yojson
    ppxlib
    process
    sedlex
    stdint
    yojson
    zarith
  ];

  enableParallelBuilding = true;
}
