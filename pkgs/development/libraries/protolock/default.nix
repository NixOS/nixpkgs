{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protolock";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "nilslice";
    repo = "protolock";
    rev = "v${version}";
    sha256 = "sha256-vWwRZVArmlTIGwD4zV3dEHN2kkoeCZuNIvjCBVAviPo=";
  };

  vendorSha256 = "sha256-pYtP+Tkh2TcGsbk7zQNaoYLEQrqGOL0gkMG5dUkfpt4=";

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
