{ lib
, fetchFromGitHub
, buildGoModule
, fuse
}:

let
  fuseftp = buildGoModule rec {
    pname = "go-fuseftp";
    version = "0.4.2";

    src = fetchFromGitHub {
      owner = "datawire";
      repo = "go-fuseftp";
      rev = "v${version}";
      hash = "sha256-bkaC+EOqFPQA4fDkVhO6EqgGhOJy31yGwVbbPoRd+70=";
    };

    vendorHash = "sha256-Dk4wvg2lTGTw8vP42+XuvmMXeMluR0SPwlVHLEB8yCQ=";

    buildInputs = [ fuse ];

    ldflags = [ "-s" "-w" ];

    subPackages = [ "pkg/main" ];
  };
in
buildGoModule rec {
  pname = "telepresence2";
  version = "2.20.3";

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = "v${version}";
    hash = "sha256-Oi3clmECnUyz+VX1HrZRu/EUTmkQay9c/ejdcdNjoGo=";
  };

  propagatedBuildInputs = [
    fuseftp
  ];

  # telepresence depends on fuseftp existing as a built binary, as it gets embedded
  # CGO gets disabled to match their build process as that is how it's done upstream
  preBuild = ''
    cp ${fuseftp}/bin/main ./pkg/client/remotefs/fuseftp.bits
    export CGO_ENABLED=0
  '';

  vendorHash = "sha256-1Of/IBwXqyKzOSXsJE3vavurvo7ZghfBDlLn4QCR40o=";

  ldflags = [
    "-s" "-w" "-X=github.com/telepresenceio/telepresence/v2/pkg/version.Version=${src.rev}"
  ];

  subPackages = [ "cmd/telepresence" ];

  meta = with lib; {
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    homepage = "https://telepresence.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch vilsol ];
    mainProgram = "telepresence";
  };
}
