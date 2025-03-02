{
  lib,
  mkCoqDerivation,
  coq,
  itree-io,
  json,
  QuickChick,
  version ? null,
}:

mkCoqDerivation {
  pname = "async-test";
  owner = "liyishuai";
  repo = "coq-async-test";
  inherit version;

  defaultVersion =
    let
      inherit (lib.versions) range;
    in
    lib.switch coq.coq-version [
      {
        case = range "8.12" "8.19";
        out = "0.1.0";
      }
    ] null;
  release = {
    "0.1.0".sha256 = "sha256-0DBUS20337tpBi64mlJIWTQvIAdUvWbFCM9Sat7MEA8=";
  };
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [
    itree-io
    json
    QuickChick
  ];

  meta = {
    description = "From interaction trees to asynchronous tests.";
    license = lib.licenses.mpl20;
  };
}
