{ buildDunePackage, conduit
, conduit-lwt, conduit-tls, mirage-crypto-rng
}:

buildDunePackage {
  pname = "conduit-lwt-tls";

  inherit (conduit) src version useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [ conduit-lwt conduit-tls mirage-crypto-rng ];

  meta = conduit.meta // {
    description = "A portable network connection establishment library using Lwt and ocaml-tls";
  };
}
