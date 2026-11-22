{
  alcotest,
  buildDunePackage,
  ocaml,
  fetchzip,
  gcc,
  fmt,
  lib,
  uutf,
}:

buildDunePackage rec {
  pname = "yuscii";
  version = "0.3.0";

  minimalOCamlVersion = "4.03";
  duneVersion = "3";

  src = fetchzip {
    url = "https://github.com/mirage/yuscii/releases/download/v${version}/yuscii-v${version}.tbz";
    hash = "sha256-HoJjrkCb/jcAPl7dmbTdwh25SrZcF7N7nmo5wCflvkU=";
  };

  nativeCheckInputs = [
    gcc
  ];
  checkInputs = [
    alcotest
    fmt
    uutf
  ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "Simple mapper between UTF-7 to Unicode according RFC2152";
    license = lib.licenses.mit;
    homepage = "https://github.com/mirage/yuscii";
    maintainers = [ ];
  };
}
