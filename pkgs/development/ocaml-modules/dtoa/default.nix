{ stdenv, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "dtoa";
  version = "0.3.1";

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "0rzysj07z2q6gk0yhjxnjnba01vmdb9x32wwna10qk3rrb8r2pnn";
  };

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "strictoverflow";

  meta = with stdenv.lib; {
    homepage = https://github.com/flowtype/ocaml-dtoa;
    description = "Converts OCaml floats into strings (doubles to ascii, \"d to a\"), using the efficient Grisu3 algorithm.";
    license = licenses.mit;
    maintainers = [ maintainers.eqyiel ];
  };
}
