{ lib, fetchurl, buildDunePackage, result }:

buildDunePackage rec {

  pname = "ocaml-version";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/ocurrent/ocaml-version/releases/download/v${version}/ocaml-version-v${version}.tbz";
    sha256 = "0c711lifl35xila9k0rvhijy9zm3shd37q3jgw7xf01hn1swg0hn";
  };

  propagatedBuildInputs = [ result ];

  meta = {
    description = "Manipulate, parse and generate OCaml compiler version strings";
    homepage = "https://github.com/ocurrent/ocaml-version";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
