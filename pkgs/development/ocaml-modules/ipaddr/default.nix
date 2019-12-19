{ stdenv, fetchurl, buildDunePackage, ocaml
, macaddr, ounit, sexplib
}:

buildDunePackage rec {
  pname = "ipaddr";
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/archive/v${version}.tar.gz";
    sha256 = "1hi3v5dzg6h4qb268ch3h6v61gsc8bv21ajhb35z37v5nsdmyzbh";
  };

  buildInputs = [ macaddr ounit sexplib ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-ipaddr;
    description = "A library for manipulation of IP (and MAC) address representations ";
    license = licenses.isc;
    maintainers = with maintainers; [ alexfmpe ericbmerritt ];
  };
}
