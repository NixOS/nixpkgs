{ lib, buildDunePackage, fetchurl, mirage-protocols }:

buildDunePackage rec {
  pname = "mirage-stack";
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-stack/releases/download/v${version}/mirage-stack-v${version}.tbz";
    sha256 = "1xdy59bxnki1r0jwm3s8fwarhhbxr0lsqqiag5b1j41hciiqp9jq";
  };

  propagatedBuildInputs = [ mirage-protocols ];

  meta = {
    description = "MirageOS signatures for network stacks";
    homepage = "https://github.com/mirage/mirage-stack";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}

