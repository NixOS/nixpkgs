{ lib
, buildDunePackage
, num
, re
, yojson
, lwt
, fmt
, logs
, kappa-library
}:

buildDunePackage {
  pname = "kappa-binaries";
  inherit (kappa-library) version src;

  propagatedBuildInputs = [
    num
    re
    yojson
    lwt
    fmt
    logs
    kappa-library
  ];

  meta = {
    description = "Command line interfaces of the Kappa tool suite";
    homepage = "https://kappalanguage.org/";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
