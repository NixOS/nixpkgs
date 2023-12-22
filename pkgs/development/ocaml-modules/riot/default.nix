{ bigstringaf
, buildDunePackage
, fetchurl
, iomux
, lib
, mdx
, pkgs
, poll
, ptime
, telemetry
, uri
}:

buildDunePackage rec {
  pname = "riot";
  version = "0.0.6";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/leostera/riot/releases/download/${version}/riot-${version}.tbz";
    hash = "sha256-dhjnCYW+gYpwlIYQAotivyohcOq1DwzvPYqhvIZsXe0=";
  };

  checkInputs = [ mdx ];
  nativeCheckInputs = [ mdx.bin ];

  propagatedBuildInputs = [
    bigstringaf
    iomux
    poll
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
    maintainers = with lib.maintainers; [ marsam sixstring982 ];
  };
}
