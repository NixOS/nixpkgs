{ lib
, bigstringaf
, buildDunePackage
, fetchurl
, iomux
, ptime
, telemetry
, uri
}:

buildDunePackage rec {
  pname = "riot";
  version = "0.0.5";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/leostera/riot/releases/download/${version}/riot-${version}.tbz";
    hash = "sha256-Abe4LMxlaxK3MVlg2d8X60aCuPGvaOn+4zFx/uH5z4g=";
  };

  propagatedBuildInputs = [
    bigstringaf
    iomux
    ptime
    telemetry
    uri
  ];

  doCheck = true;

  meta = {
    description = "An actor-model multi-core scheduler for OCaml 5";
    homepage = "https://github.com/leostera/riot";
    changelog = "https://github.com/leostera/riot/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marsam ];
  };
}
