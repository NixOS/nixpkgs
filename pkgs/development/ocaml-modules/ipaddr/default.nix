{ lib, buildDunePackage
, macaddr, ounit
}:

buildDunePackage rec {
  pname = "ipaddr";

  inherit (macaddr) version src;

  buildInputs = [ ounit ];

  propagatedBuildInputs = [ macaddr ];

  doCheck = true;

  meta = with lib; {
    homepage = https://github.com/mirage/ocaml-ipaddr;
    description = "A library for manipulation of IP (and MAC) address representations ";
    license = licenses.isc;
    maintainers = with maintainers; [ alexfmpe ericbmerritt ];
  };
}
