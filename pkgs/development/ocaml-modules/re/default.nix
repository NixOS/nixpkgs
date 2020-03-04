{ stdenv, fetchzip, buildDunePackage, ounit, seq }:

buildDunePackage rec {
  pname = "re";
  version = "1.9.0";

  minimumOCamlVersion = "4.02";

  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-re/archive/${version}.tar.gz";
    sha256 = "07ycb103mr4mrkxfd63cwlsn023xvcjp0ra0k7n2gwrg0mwxmfss";
  };

  buildInputs = [ ounit ];
  propagatedBuildInputs = [ seq ];
  doCheck = true;

  meta = {
    homepage = https://github.com/ocaml/ocaml-re;
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
