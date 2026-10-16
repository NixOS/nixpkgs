{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppx_expect,
  ppx_inline_test,
}:

buildDunePackage (finalAttrs: {
  pname = "ocplib_stuff";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocplib_stuff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eTRdsJttkIthdgGbBEosjgrzES29kgQV2WaIAGCixTo=";
  };

  propagatedBuildInputs = [
    ppx_expect
    ppx_inline_test
  ];

  doCheck = true;

  meta = {
    description = "Some basic stuff that is used in some OCP libraries and applications";
    homepage = "https://github.com/OCamlPro/ocplib_stuff";
    license = lib.licenses.WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
