{ buildDunePackage, conduit
, ke, tls, logs, bigstringaf
}:

buildDunePackage {
  pname = "conduit-tls";

  inherit (conduit) src version useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [ conduit ke tls logs bigstringaf ];

  meta = conduit.meta // {
    description = "A network connection establishment library with TLS/SSL support";
  };
}
