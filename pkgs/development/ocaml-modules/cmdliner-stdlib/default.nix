{
  lib,
  fetchurl,
  buildDunePackage,
  cmdliner,
}:

buildDunePackage (finalAttrs: {
  pname = "cmdliner-stdlib";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/cmdliner-stdlib/releases/download/${finalAttrs.version}/cmdliner-stdlib-${finalAttrs.version}.tbz";
    hash = "sha256-GbW5Y8Ibb+mNL2LkBOU2EcO8x7r1OO/QH1mO+Sgleq4=";
  };

  propagatedBuildInputs = [ cmdliner ];

  doCheck = true;

  meta = {
    description = "Collection of cmdliner terms to control OCaml runtime parameters";
    homepage = "https://github.com/mirage/cmdliner-stdlib";
    changelog = "https://raw.githubusercontent.com/mirage/cmdliner-stdlib/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.stepbrobd ];
  };
})
