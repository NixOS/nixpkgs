{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protolock";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "nilslice";
    repo = "protolock";
    rev = "v${version}";
    sha256 = "sha256-cKrG8f8cabuGDN1gmBYleXcBqeJksdREiEy63UK/6J0=";
  };

  vendorSha256 = "sha256-2XbBiiiPvZCnlKUzGDLFnxA34N/LmHoPbvRKZckmhx4=";

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
