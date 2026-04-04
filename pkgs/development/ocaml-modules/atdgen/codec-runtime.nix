{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "atdgen-codec-runtime";
  version = "4.0.0";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${finalAttrs.version}/atd-${finalAttrs.version}.tbz";
    hash = "sha256-NRT+TcTniGQLPpqf7DtbEG5vYJtZ0oUicB3hvS6pCfE=";
  };

  meta = {
    description = "Runtime for atdgen generated bucklescript converters";
    homepage = "https://github.com/ahrefs/atd";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
})
