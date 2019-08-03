{ buildDunePackage, sqlexpr, ounit
, ppx_core, ppx_tools_versioned, re, lwt_ppx
}:

buildDunePackage {
  pname = "ppx_sqlexpr";
  inherit (sqlexpr) version src meta;

  buildInputs = [ sqlexpr ounit ppx_core ppx_tools_versioned re lwt_ppx ];
  doCheck = true;
}
