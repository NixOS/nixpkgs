{ lib, fetchzip, buildDunePackage, ocaml, ounit, seq }:

buildDunePackage rec {
  pname = "re";
  version = "1.9.0";

  minimumOCamlVersion = "4.02";

  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-re/archive/${version}.tar.gz";
    sha256 = "07ycb103mr4mrkxfd63cwlsn023xvcjp0ra0k7n2gwrg0mwxmfss";
  };

  buildInputs = lib.optional doCheck ounit;
  propagatedBuildInputs = [ seq ];
  doCheck = lib.versionAtLeast ocaml.version "4.04";

  meta = {
    homepage = "https://github.com/ocaml/ocaml-re";
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
