{ lib, fetchFromGitHub, buildDunePackage, ocaml, owee }:

lib.throwIfNot (lib.versionAtLeast "4.12" ocaml.version)
  "spacetime_lib is not available for OCaml ${ocaml.version}"

buildDunePackage rec {
  pname = "spacetime_lib";
  version = "0.3.0";
  duneVersion = "2";

  src = fetchFromGitHub {
    owner = "lpw25";
    repo = "spacetime_lib";
    rev = version;
    sha256 = "0biisgbycr5v3nm5jp8i0h6vq76vzasdjkcgh8yr7fhxc81jgv3p";
  };

  patches = [ ./spacetime.diff ];

  propagatedBuildInputs = [ owee ];

  preConfigure = ''
    bash ./configure.sh
  '';

  meta = {
    description = "An OCaml library providing some simple operations for handling OCaml “spacetime” profiles";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
