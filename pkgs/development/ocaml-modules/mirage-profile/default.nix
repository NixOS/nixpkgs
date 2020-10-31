{ lib, fetchurl, buildDunePackage
, ppx_cstruct
, cstruct, lwt
}:

buildDunePackage rec {
  pname = "mirage-profile";
  version = "0.9.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-profile/releases/download/v${version}/mirage-profile-v${version}.tbz";
    sha256 = "0lh3591ad4v7nxpd410b75idmgdq668mqdilvkg4avrwqw1wzdib";
  };

  buildInputs = [ ppx_cstruct ];
  propagatedBuildInputs = [ cstruct lwt ];

  meta = {
    description = "Collect runtime profiling information in CTF format";
    homepage = "https://github.com/mirage/mirage-profile";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
