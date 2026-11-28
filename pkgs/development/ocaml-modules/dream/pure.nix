{
  lib,
  buildDunePackage,
  fetchurl,
  lwt_ppx,
  base64,
  hmap,
  lwt,
  ptime,
  uri,
}:

buildDunePackage (finalAttrs: {
  pname = "dream-pure";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/camlworks/dream/releases/download/${finalAttrs.version}/dream-${finalAttrs.version}.tbz";
    hash = "sha256-vrNn6aviUJfGxDxGbm7ZrDJJI9sKzczazoNl9SEPhW4=";
  };

  buildInputs = [ lwt_ppx ];

  propagatedBuildInputs = [
    base64
    hmap
    lwt
    ptime
    uri
  ];

  meta = {
    description = "Shared HTTP types for Dream (server) and Hyper (client)";
    homepage = "https://camlworks.github.io/dream/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
