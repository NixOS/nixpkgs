{ lib, fetchurl, buildDunePackage, ocaml, ounit, seq }:

buildDunePackage rec {
  pname = "re";
  version = "1.9.0";

  minimumOCamlVersion = "4.02";

  useDune2 = lib.versionAtLeast ocaml.version "4.08";

  src = fetchurl {
    url = "https://github.com/ocaml/ocaml-re/releases/download/${version}/re-${version}.tbz";
    sha256 = "1gas4ky49zgxph3870nffzkr6y41kkpqp4nj38pz1gh49zcf12aj";
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
