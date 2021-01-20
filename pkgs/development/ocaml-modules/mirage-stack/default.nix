{ lib, buildDunePackage, fetchurl, mirage-protocols }:

buildDunePackage rec {
  pname = "mirage-stack";
  version = "2.2.0";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-stack/releases/download/v${version}/mirage-stack-v${version}.tbz";
    sha256 = "1qhi0ghcj4j3hw7yqn085ac6n18b6b66z5ih3k8p79m4cvn7cdq0";
  };

  propagatedBuildInputs = [ mirage-protocols ];

  meta = {
    description = "MirageOS signatures for network stacks";
    homepage = "https://github.com/mirage/mirage-stack";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}

