{
  lib,
  fetchurl,
  buildDunePackage,
  re,
  stdlib-shims,
  uuidm,
}:

buildDunePackage rec {
  pname = "redis";
  version = "0.8";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/0xffea/ocaml-redis/releases/download/v${version}/redis-${version}.tbz";
    hash = "sha256-Cli30Elur3tL/0bWK6PBBy229TK4jsQnN/0oVQux01I=";
  };

  propagatedBuildInputs = [
    re
    stdlib-shims
    uuidm
  ];

  doCheck = true;

  meta = {
    description = "Redis client";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/0xffea/ocaml-redis";
  };
}
