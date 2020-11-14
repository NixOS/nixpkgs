{ buildDunePackage, conduit
}:

buildDunePackage {
  pname = "conduit-mirage";

  inherit (conduit) src version useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [
    ke tcpip mirage-flow mirage-time dns-client ke bigstringaf
  ];

  meta = conduit.meta // {
    description = "A network connection establishment library for MirageOS";
  };
}
