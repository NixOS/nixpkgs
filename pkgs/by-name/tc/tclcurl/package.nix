{
  lib,
  tcl,
  fetchFromGitHub,
  curl,
}:

tcl.mkTclDerivation rec {
  pname = "tclcurl";
  version = "7.22.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "tclcurl-fa";
    rev = "refs/tags/v${version}";
    hash = "sha256-XQuP+SiqvGX3ckBShUxsGBADjV3QdvYpU4hW6LMbMMQ=";
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
