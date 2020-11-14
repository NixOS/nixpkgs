{ buildDunePackage, conduit, conduit-lwt, lwt_ssl }:

buildDunePackage {
  pname = "conduit-lwt-ssl";

  inherit (conduit) src version useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [ conduit-lwt lwt_ssl ];

  meta = conduit.meta // {
    description = "A portable network connection establishment library using Lwt and OpenSSL";
  };
}
