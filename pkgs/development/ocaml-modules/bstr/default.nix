{
  fetchurl,
  buildDunePackage,
  lib,
}:

buildDunePackage rec {
  pname = "bstr";
  version = "0.0.3";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/robur-coop/bstr/releases/download/v${version}/bstr-${version}.tbz";
    hash = "sha256-UDxPdPZ9FuMN2WKnU+07yhRpKCwiAjkvWw4bfiqbRWI=";
  };

  meta = {
    description = "A simple library for bigstrings";
    homepage = "https://git.robur.coop/robur/bstr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
