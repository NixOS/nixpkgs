{ lib, buildDunePackage, fetchurl, pcre, dune-configurator }:

buildDunePackage rec {
  pname = "pcre";
  version = "7.4.6";

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mmottl/pcre-ocaml/releases/download/${version}/pcre-${version}.tbz";
    sha256 = "17ajl0ra5xkxn5pf0m0zalylp44wsfy6mvcq213djh2pwznh4gya";
  };

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ pcre ];

  meta = with lib; {
    homepage = "https://mmottl.github.io/pcre-ocaml";
    description = "An efficient C-library for pattern matching with Perl-style regular expressions in OCaml";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ maggesi vbmithr ];
  };
}
