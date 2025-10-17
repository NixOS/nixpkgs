{
  buildDunePackage,
  xtmpl,
  ppxlib,
}:

buildDunePackage {
  pname = "xtmpl_ppx";

  inherit (xtmpl) src version;

  # Fix for ppxlib ≥ 0.37
  postPatch = ''
    substituteInPlace ppx/ppx_xtmpl.ml --replace-fail 'Parse.longident b' \
      'Astlib.Longident.parse s'
  '';

  buildInputs = [
    ppxlib
    xtmpl
  ];

  meta = xtmpl.meta // {
    description = "Xml templating library, ppx extension";
  };
}
