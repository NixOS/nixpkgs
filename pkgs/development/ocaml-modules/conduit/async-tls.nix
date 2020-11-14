{ buildDunePackage, conduit
, conduit-async, conduit-tls, async, core
}:

buildDunePackage {
  pname = "conduit-async-tls";

  inherit (conduit) src version useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [ conduit-async conduit-tls async core ];

  meta = conduit.meta // {
    description = "A portable network connection establishment library using Async and ocaml-tls";
  };
}
