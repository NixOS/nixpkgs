{
  buildDunePackage,
  cohttp,
  cohttp-lwt-unix,
  http,
  lwt,
  ppx_expect,
}:

buildDunePackage (finalAttrs: {
  pname = "cohttp-server-lwt-unix";
  inherit (cohttp) version src;

  propagatedBuildInputs = [
    http
    lwt
  ];

  checkInputs = [
    cohttp-lwt-unix
    ppx_expect
  ];
  doCheck = true;

  meta = cohttp.meta // {
    description = "Lightweight Cohttp + Lwt based HTTP server";
  };
})
