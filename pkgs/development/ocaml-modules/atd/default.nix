{ stdenv, menhir, easy-format, ocaml, findlib, fetchurl, jbuilder, which }:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then {
    version = "1.12.0";
    sha256 = "1pcd4fqbilv8zm2mc1nj2s26vc5y8vnisg1q1y6bjx23wxidb09y";
    buildPhase = "jbuilder build -p atd";
    inherit (jbuilder) installPhase;
  } else {
    version = "1.1.2";
    sha256 = "0ef10c63192aed75e9a4274e89c5f9ca27efb1ef230d9949eda53ad4a9a37291";
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/bin
      make PREFIX=$out install
    '';
  };
in

stdenv.mkDerivation rec {
  inherit (param) version buildPhase installPhase;
  name = "ocaml${ocaml.version}-atd-${version}";

  src = fetchurl {
    url = "https://github.com/mjambon/atd/archive/v${version}.tar.gz";
    inherit (param) sha256;
  };

  createFindlibDestdir = true;

  buildInputs = [ which jbuilder ocaml findlib menhir ];
  propagatedBuildInputs = [ easy-format ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mjambon/atd;
    description = "Syntax for cross-language type definitions";
    license = licenses.bsd3;
    maintainers = [ maintainers.jwilberding ];
  };
}
