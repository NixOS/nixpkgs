{ lib
, buildDunePackage
, fetchFromGitHub
, num
, re
, yojson
, lwt
, stdlib-shims
, fmt
, logs
, result
, camlp-streams
}:

buildDunePackage {
  pname = "kappa-library";
  version = "4.1-unstable-2023-11-30";

  src = fetchFromGitHub {
    owner = "Kappa-Dev";
    repo = "KappaTools";
    rev = "e01791c5487be46e5912150e57375e4b83391a1e";
    hash = "sha256-DINok0LviwO7UMhjjq9c0KGv9mdlpsbzivij2imOoxI=";
  };

  propagatedBuildInputs = [
    num
    re
    yojson
    lwt
    stdlib-shims
    fmt
    logs
    result
    camlp-streams
  ];

  meta = {
    description = "Public internals of the Kappa tool suite";
    homepage = "https://kappalanguage.org/";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
