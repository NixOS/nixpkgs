{ lib
, bigstringaf
, buildDunePackage
, fetchurl
, iomux
, ptime
, uri
}:

buildDunePackage rec {
  pname = "riot";
  version = "0.0.2";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/leostera/riot/releases/download/${version}/riot-${version}.tbz";
    hash = "sha256-ck/tr5o0nKF4WNgjPODHg1/tlaKv1JtuYgqYfIIZ78Q=";
  };

  propagatedBuildInputs = [
    bigstringaf
    iomux
    ptime
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
