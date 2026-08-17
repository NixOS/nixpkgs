{
  buildDunePackage,
  cohttp,
  cohttp-lwt-unix,
  http,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "cohttp-server-lwt-unix";
  inherit (cohttp) version src;

  propagatedBuildInputs = [
    http
    lwt
  ];

  checkInputs = [ cohttp-lwt-unix ];
  doCheck = true;

  meta = cohttp.meta // {
    description = "Lightweight Cohttp + Lwt based HTTP server";
  };
})
