{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protolock";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "nilslice";
    repo = "protolock";
    rev = "v${version}";
    sha256 = "sha256-rnsHVJHFE/8JIOfMWqGBfIbIuOFyHtT54Vu/DaRY9js=";
  };

  vendorSha256 = "sha256-3kRGLZgYcbUQb6S+NrleMNNX0dXrE9Yer3vvqxiP4So=";

  doCheck = false;

  postInstall = ''
    rm $out/bin/plugin*
  '';

  meta = with lib; {
    description = "Protocol Buffer companion tool. Track your .proto files and prevent changes to messages and services which impact API compatibility. https://protolock.dev";
    homepage = "https://github.com/nilslice/protolock";
    license = licenses.bsd3;
    maintainers = with maintainers; [ groodt ];
  };
}
