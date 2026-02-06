{
  lib,
  ocaml,
  buildDunePackage,
  dolmen,
  dolmen_type,
  gen,
  pp_loc,
  mdx,
}:

buildDunePackage {
  pname = "dolmen_loop";
  inherit (dolmen) src version;

  env =
    # Fix build with gcc15
    lib.optionalAttrs
      (
        lib.versionAtLeast ocaml.version "4.10" && lib.versionOlder ocaml.version "4.14"
        || lib.versions.majorMinor ocaml.version == "5.0"
      )
      {
        NIX_CFLAGS_COMPILE = "-std=gnu11";
      };

  propagatedBuildInputs = [
    dolmen
    dolmen_type
    gen
    pp_loc
  ];

  doCheck = true;
  nativeCheckInputs = [ mdx.bin ];
  checkInputs = [ mdx ];

  meta = dolmen.meta // {
    description = "Tool library for automated deduction tools";
  };
}
