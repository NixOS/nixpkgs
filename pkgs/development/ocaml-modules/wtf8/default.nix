{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "wtf8";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-wtf8/releases/download/v${finalAttrs.version}/wtf8-v${finalAttrs.version}.tbz";
    hash = "sha256-d5/3KUBAWRj8tntr4RkJ74KWW7wvn/B/m1nx0npnzyc=";
  };

  meta = {
    homepage = "https://github.com/flowtype/ocaml-wtf8";
    description = "WTF-8 is a superset of UTF-8 that allows unpaired surrogates";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eqyiel ];
  };
})
