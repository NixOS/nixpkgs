{ buildDunePackage, sqlexpr, ounit
, ppxlib, ppx_tools_versioned, re, lwt_ppx
}:

buildDunePackage {
  pname = "ppx_sqlexpr";
  inherit (sqlexpr) version src meta;

  postPatch = ''
    substituteInPlace src/ppx/jbuild --replace ppx_core ppxlib
  '';

  buildInputs = [ sqlexpr ounit ppxlib ppx_tools_versioned re lwt_ppx ];
  doCheck = true;
}
