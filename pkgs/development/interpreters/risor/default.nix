{ lib
, buildGo121Module
, fetchFromGitHub
, testers
, risor
}:

buildGo121Module rec {
  pname = "risor";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "risor-io";
    repo = "risor";
    rev = "v${version}";
    hash = "sha256-7/pGC2+7KKc+1JZrPnchG3/Zj15lfcvTppuFUcpu/aU=";
  };

  proxyVendor = true;
  vendorHash = "sha256-6Zb30IXZsRQ0mvJOf4yDPkk7I+s18ok/V90mSKB/Ev4=";

  subPackages = [
    "cmd/risor"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = risor;
      command = "risor version";
    };
  };

  meta = with lib; {
    description = "Fast and flexible scripting for Go developers and DevOps";
    homepage = "https://github.com/risor-io/risor";
    changelog = "https://github.com/risor-io/risor/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}

