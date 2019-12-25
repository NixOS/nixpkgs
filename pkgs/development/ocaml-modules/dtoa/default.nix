{ stdenv, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "dtoa";
  version = "0.3.2";

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0zkhn0rdq82g6gamsv6nkx6i44s8104nh6jg5xydazl9jl1704xn";
  };

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "strictoverflow";

  meta = with stdenv.lib; {
    homepage = https://github.com/flowtype/ocaml-dtoa;
    description = "Converts OCaml floats into strings (doubles to ascii, \"d to a\"), using the efficient Grisu3 algorithm.";
    license = licenses.mit;
    maintainers = [ maintainers.eqyiel ];
  };
}
