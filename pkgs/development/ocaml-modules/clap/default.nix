{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "clap";
  version = "0.3.0";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "rbardou";
    repo = "clap";
    rev = finalAttrs.version;
    hash = "sha256-IEol27AVYs55ntvNprBxOk3/EsBKAdPkF3Td3w9qOJg=";
  };

  meta = {
    description = "Command-Line Argument Parsing, imperative style with a consumption mechanism";
    license = lib.licenses.mit;
  };
})
