{ lib
, buildDunePackage
, num
, re
, yojson
, lwt
, fmt
, logs
, kappa-library
, atdgen-runtime
, atdgen
}:

buildDunePackage {
  pname = "kappa-agents";
  inherit (kappa-library) version src;

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
    kappa-library
    atdgen-runtime
  ];

  meta = {
    description = "Backends for an interactive use of the Kappa tool suite";
    homepage = "https://kappalanguage.org/";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
