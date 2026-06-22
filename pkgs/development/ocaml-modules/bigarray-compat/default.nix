{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "bigarray-compat";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/bigarray-compat/releases/download/v${finalAttrs.version}/bigarray-compat-${finalAttrs.version}.tbz";
    hash = "sha256-Q0RppI1chOgNYhsT2V6wZ/gTjBZQof1a5gCaGbk3GNU=";
  };

  meta = {
    description = "Compatibility library to use Stdlib.Bigarray when possible";
    homepage = "https://github.com/mirage/bigarray-compat";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
