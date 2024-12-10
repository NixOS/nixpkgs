{
  lib,
  buildDunePackage,
  cstruct,
  fetchurl,
  mdx,
  poll,
  ptime,
  telemetry,
  uri,
}:

buildDunePackage rec {
  pname = "riot";
  version = "0.0.7";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/leostera/riot/releases/download/${version}/riot-${version}.tbz";
    hash = "sha256-t+PMBh4rZXi82dUljv3nLzZX5o1iagBbQ9FfGnr/dp4=";
  };

  propagatedBuildInputs = [
    cstruct
    poll
    ptime
    telemetry
    uri
  ];

  checkInputs = [
    mdx
    mdx.bin
  ];

  doCheck = false; # fails on sandbox

  meta = {
    description = "An actor-model multi-core scheduler for OCaml 5";
    homepage = "https://github.com/leostera/riot";
    changelog = "https://github.com/leostera/riot/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
