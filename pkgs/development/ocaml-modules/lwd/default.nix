{
  lib,
  fetchurl,
  buildDunePackage,
  seq,
}:

buildDunePackage (finalAttrs: {
  pname = "lwd";
  version = "0.5";

  src = fetchurl {
    url = "https://github.com/let-def/lwd/releases/download/v${finalAttrs.version}/lwd-${finalAttrs.version}.tbz";
    hash = "sha256-YAZjeLuhAxUCB3RrBul4u70g5TEqT2C7Z09YbYyPZOY=";
  };

  propagatedBuildInputs = [ seq ];

  meta = {
    description = "Lightweight reactive documents";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
})
