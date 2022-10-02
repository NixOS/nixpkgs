{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "pprint";
  version = "20220103";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "fpottier";
    repo = pname;
    rev = version;
    sha256 = "sha256:09y6nwnjldifm47406q1r9987njlk77g4ifqg6qs54dckhr64vax";
  };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "An OCaml library for pretty-printing textual documents";
    license = licenses.lgpl2Only;
    maintainers = [ maintainers.vbgl ];
  };
}
