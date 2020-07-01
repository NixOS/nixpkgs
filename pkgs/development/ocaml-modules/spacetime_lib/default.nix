{ lib, fetchFromGitHub, buildDunePackage, owee }:

buildDunePackage rec {
  pname = "spacetime_lib";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lpw25";
    repo = "spacetime_lib";
    rev = version;
    sha256 = "0biisgbycr5v3nm5jp8i0h6vq76vzasdjkcgh8yr7fhxc81jgv3p";
  };

  propagatedBuildInputs = [ owee ];

  meta = {
    description = "An OCaml library providing some simple operations for handling OCaml “spacetime” profiles";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
