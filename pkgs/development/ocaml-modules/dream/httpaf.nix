{
  buildDunePackage,
  dream-pure,
  lwt_ppx,
  httpun-ws,
}:

buildDunePackage {
  pname = "dream-httpaf";

  inherit (dream-pure) version src;

  buildInputs = [ lwt_ppx ];
  propagatedBuildInputs = [
    dream-pure
    httpun-ws
  ];

  meta = dream-pure.meta // {
    description = "Shared http/af stack for Dream (server) and Hyper (client)";
  };
}
