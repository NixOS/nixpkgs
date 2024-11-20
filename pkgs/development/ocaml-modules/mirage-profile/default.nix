{ lib, fetchurl, buildDunePackage
, ppx_cstruct, stdlib-shims
, cstruct, lwt
}:

buildDunePackage rec {
  pname = "mirage-profile";
  version = "0.9.1";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-profile/releases/download/v${version}/mirage-profile-v${version}.tbz";
    sha256 = "0lh3591ad4v7nxpd410b75idmgdq668mqdilvkg4avrwqw1wzdib";
  };

  buildInputs = [ ppx_cstruct ];
  propagatedBuildInputs = [ cstruct lwt stdlib-shims ];

  meta = with lib; {
    description = "Collect runtime profiling information in CTF format";
    homepage = "https://github.com/mirage/mirage-profile";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vbgl ];
  };
}
