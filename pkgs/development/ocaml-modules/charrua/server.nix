{
  buildDunePackage,
  alcotest,
  charrua,
  cstruct,
  cstruct-unix,
  ipaddr,
  macaddr,
  menhir,
}:

buildDunePackage {
  pname = "charrua-server";
  inherit (charrua) version src;

  __structuredAttrs = true;

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    charrua
    cstruct
    ipaddr
    macaddr
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    cstruct-unix
  ];

  meta = charrua.meta // {
    description = "DHCP server library";
  };
}
