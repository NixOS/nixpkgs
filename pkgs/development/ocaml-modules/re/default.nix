{ stdenv, fetchzip, buildDunePackage, ounit, seq }:

buildDunePackage rec {
  pname = "re";
  version = "1.8.0";

  minimumOCamlVersion = "4.02";

  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-re/archive/${version}.tar.gz";
    sha256 = "0ch6hvmm4ym3w2vghjxf3ka5j1023a37980fqi4zcb7sx756z20i";
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
