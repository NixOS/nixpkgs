{ lib, fetchurl, buildDunePackage
, cstruct, lwt, fmt
}:

buildDunePackage rec {
  pname = "mirage-block";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-block/releases/download/v${version}/mirage-block-v${version}.tbz";
    sha256 = "sha256-NB5nJpppMtdi0HDjKcCAqRjO4vIbAMfnP934P+SnzmU=";
  };

  propagatedBuildInputs = [ cstruct lwt fmt ];

  meta = with lib; {
    description = "Block signatures and implementations for MirageOS";
    homepage = "https://github.com/mirage/mirage-block";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
