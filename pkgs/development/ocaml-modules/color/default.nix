{
  lib,
  fetchurl,
  buildDunePackage,
  gg,
}:

buildDunePackage (finalAttrs: {
  pname = "color";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/anuragsoni/color/releases/download/${finalAttrs.version}/color-${finalAttrs.version}.tbz";
    hash = "sha256-8BZjdafFnFTTz75be+5vJnP42vr4FHfLt+6oEM1Q43E=";
  };

  propagatedBuildInputs = [
    gg
  ];

  meta = {
    description = "Converts between different color formats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    homepage = "https://github.com/anuragsoni/color";
  };
})
