{
  lib,
  buildDunePackage,
  fetchurl,
  pcre,
  dune-configurator,
}:

buildDunePackage rec {
  pname = "pcre";
  version = "8.0.4";

  useDune2 = true;

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/mmottl/pcre-ocaml/releases/download/${version}/pcre-${version}.tbz";
    sha256 = "sha256-CIoy3Co4YnVZ5AkEjkUarqV0u08ZAqU0IQsaL1SnuCA=";
  };

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ pcre ];

  meta = with lib; {
    homepage = "https://mmottl.github.io/pcre-ocaml";
    description = "Efficient C-library for pattern matching with Perl-style regular expressions in OCaml";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      vbmithr
    ];
  };
}
