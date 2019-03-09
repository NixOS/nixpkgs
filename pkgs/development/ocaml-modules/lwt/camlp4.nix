{ lib, fetchFromGitHub, buildDunePackage, camlp4 }:

buildDunePackage rec {
  pname = "lwt_camlp4";
  version = "git-20180325";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = pname;
    rev = "45f25a081e01071ab566924b48ba5f7553bb33ac";
    sha256 = "1lv8z6ljfy47yvxmwf5jrvc5d3dc90r1n291x53j161sf22ddrk9";
  };

  minimumOCamlVersion = "4.02";

  propagatedBuildInputs = [ camlp4 ];

  meta = {
    description = "Camlp4 syntax extension for Lwt (deprecated)";
    license = lib.licenses.lgpl21;
    inherit (src.meta) homepage;
    maintainers = [ lib.maintainers.vbgl ];
  };
}

