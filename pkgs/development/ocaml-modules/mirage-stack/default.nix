{ lib, buildDunePackage, fetchurl, mirage-protocols }:

buildDunePackage rec {
  pname = "mirage-stack";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-stack/releases/download/v${version}/mirage-stack-v${version}.tbz";
    sha256 = "1y110i4kjr03b0ji3q5h0bi3n3q8mdkfflb3fyq5rvpi5l45vvdb";
  };

  propagatedBuildInputs = [ mirage-protocols ];

  meta = {
    description = "MirageOS signatures for network stacks";
    homepage = "https://github.com/mirage/mirage-stack";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}

