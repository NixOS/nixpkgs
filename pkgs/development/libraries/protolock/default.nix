{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protolock";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "nilslice";
    repo = "protolock";
    rev = "v${version}";
    sha256 = "0qg26vcqdhgy91p6wiv16dq73ay0fymran3d8ylca9264zwi2vxw";
  };

  vendorSha256 = "0ap1iwcapvvvmwgdc4zbsp8mglrhbswkdgm4dw8baw8qk0nlci6y";

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
