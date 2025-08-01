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

buildDunePackage rec {
  pname = "dream-pure";
  version = "1.0.0-alpha8";

  src = fetchurl {
    url = "https://github.com/aantron/dream/releases/download/${version}/dream-${version}.tar.gz";
    hash = "sha256-I+2BKJDAP+XJl0pJYano5iEmvte8fX0UQLhGUslc8pY=";
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
    homepage = "https://aantron.github.io/dream/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
