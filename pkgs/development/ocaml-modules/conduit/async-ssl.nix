{ buildDunePackage, conduit
, conduit-async, async, async_ssl, core
}:

buildDunePackage {
  pname = "conduit-async-ssl";

  inherit (conduit) src version useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [ conduit-async async async_ssl core ];

  meta = conduit.meta // {
    description = "A portable network connection establishment library using Async and OpenSSL";
  };
}
