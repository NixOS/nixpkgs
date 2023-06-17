{ lib, buildDunePackage, fetchurl, tcpip }:

buildDunePackage rec {
  pname = "mirage-stack";
  version = "4.0.0";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-stack/releases/download/v${version}/mirage-stack-v${version}.tbz";
    hash = "sha256-q70zGQvT5KTqvL37bZjSD8Su0P72KCUesyfWJcI8zPw=";
  };

  propagatedBuildInputs = [ tcpip ];

  meta = {
    description = "MirageOS signatures for network stacks";
    homepage = "https://github.com/mirage/mirage-stack";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}

