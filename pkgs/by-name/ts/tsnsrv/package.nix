{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tsnsrv";
  version = "0-unstable-2024-02-14";

  src = fetchFromGitHub {
    owner = "boinkor-net";
    repo = "tsnsrv";
    rev = "b07362e2e225a295c2544abffe25dda68133f06e";
    hash = "sha256-JQ1pkasPrmw+2QhSw75520ZRq4PfnYDNK0XK5/+SG60=";
  };

  vendorHash = "sha256-CWqlotDOs2aJTwkR5AcngThehInH7QKxpj4gjnx5Ygs=";

  meta = with lib; {
    description = "A reverse proxy that exposes services on your tailnet";
    homepage = "https://github.com/boinkor-net/tsnsrv";
    license = licenses.mit;
    maintainers = with maintainers; [ patka ];
    mainProgram = "tsnsrv";
  };
}
