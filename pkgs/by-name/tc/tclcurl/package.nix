{
  lib,
  tcl,
  fetchFromGitHub,
  curl,
}:

tcl.mkTclDerivation rec {
  pname = "tclcurl";
  version = "7.22.0";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "tclcurl-fa";
    rev = "refs/tags/v${version}";
    hash = "sha256-FQSzujHuP7vGJ51sdXh+31gRKqn98dV1kIqMKSoVB0M=";
  };

  buildInputs = [ curl ];

  # Uses curl-config
  strictDeps = false;

  makeFlags = [ "LDFLAGS=-lcurl" ];

  meta = {
    description = "Curl support in Tcl";
    homepage = "https://github.com/flightaware/tclcurl-fa";
    changelog = "https://github.com/flightaware/tclcurl-fa/blob/master/ChangeLog.txt";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
