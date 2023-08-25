{ lib, buildNimPackage, fetchFromSourcehut, fetchFromGitHub }:

let
  # freedesktop_org requires a fork of configparser
  configparser = buildNimPackage rec {
    pname = "configparser";
    version = "20230120";
    src = fetchFromGitHub {
      repo = "nim-" + pname;
      owner = "ehmry";
      rev = "695f1285d63f1954c25eb1f42798d90fa7bcbe14";
      hash = "sha256-Z2Qr14pv2RHzQNfEYIKuXKHfHvvIfaEiGCHHCWJZFyw=";
    };
  };
in buildNimPackage rec {
  pname = "freedesktop_org";
  version = "20230201";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = pname;
    rev = version;
    hash = "sha256-gEN8kiWYCfC9H7o4UE8Xza5s7OwU3TFno6XnIlEm9Dg=";
  };
  propagatedBuildInputs = [ configparser ];
  meta = src.meta // {
    description = "Some Nim procedures for looking up freedesktop.org data";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
