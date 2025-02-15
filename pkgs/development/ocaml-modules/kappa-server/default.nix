{ lib
, buildDunePackage
, num
, re
, yojson
, lwt
, fmt
, logs
, kappa-binaries
, kappa-agents
, cohttp-lwt-unix
, atdgen-runtime
, atdgen
}:

buildDunePackage {
  pname = "kappa-server";
  inherit (kappa-binaries) version src;

  nativeBuildInputs = [
    atdgen
  ];

  propagatedBuildInputs = [
    num
    re
    yojson
    lwt
    fmt
    logs
    kappa-binaries
    kappa-agents
    cohttp-lwt-unix
    atdgen-runtime
  ];

  meta = {
    description = "HTTP server to query the Kappa tool suite";
    homepage = "https://kappalanguage.org/";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
