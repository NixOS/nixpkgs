{ lib
, buildDunePackage
, fetchurl
, fetchpatch
, mirage-crypto-rng
, mtime
, gluon
, randomconv
, rio
, telemetry
, tls
}:

buildDunePackage rec {
  pname = "riot";
  version = "0.0.8";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/leostera/riot/releases/download/${version}/riot-${version}.tbz";
    hash = "sha256-SsiDz53b9bMIT9Q3IwDdB3WKy98WSd9fiieU41qZpeE=";
  };

  # Compatibility with tls 0.17.5
  patches = fetchpatch {
    url = "https://github.com/riot-ml/riot/commit/bbbf0efce6dc84afba84e84cc231ce7ef2dcaa91.patch";
    hash = "sha256-qsPuEpur5DohOGezSTpOyBq9WxnY9OS6+w2Ls0tZkT8=";
    includes = [ "riot/lib/ssl.ml" ];
  };

  propagatedBuildInputs = [
    gluon
    mirage-crypto-rng
    mtime
    randomconv
    rio
    telemetry
    tls
  ];

  doCheck = false; # fails on sandbox

  meta = {
    description = "Actor-model multi-core scheduler for OCaml 5";
    homepage = "https://github.com/leostera/riot";
    changelog = "https://github.com/leostera/riot/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
