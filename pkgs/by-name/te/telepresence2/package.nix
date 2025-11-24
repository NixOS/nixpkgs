{
  lib,
  fetchFromGitHub,
  buildGoModule,
  fuse,
}:

let
  fuseftp = buildGoModule rec {
    pname = "go-fuseftp";
    version = "0.6.6";

    src = fetchFromGitHub {
      owner = "datawire";
      repo = "go-fuseftp";
      rev = "v${version}";
      hash = "sha256-70VmT8F+RNiDk6fnrzDktdfNhZk20sXF+b3TBTAkNHo=";
    };

    vendorHash = "sha256-wp4jOmeVdfuRwdclCzBonNCkhgsNUBOBL6gxlrznC1A=";

    buildInputs = [ fuse ];

    ldflags = [
      "-s"
      "-w"
    ];

    subPackages = [ "pkg/main" ];
  };
in
buildGoModule rec {
  pname = "telepresence2";
  version = "2.25.1";

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = "v${version}";
    hash = "sha256-Itj+tC5OclTXsRdJ6Rh4xQ1YwMSZTTdcRzpUQrmpC0M=";
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

  vendorHash = "sha256-iNvvFl05Q/6uXDSYyAijayXfvObmwh6aDR6XmFQkSHI=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/telepresenceio/telepresence/v2/pkg/version.Version=${src.rev}"
  ];

  subPackages = [ "cmd/telepresence" ];

  meta = with lib; {
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    homepage = "https://telepresence.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
      mausch
      vilsol
      wrbbz
    ];
    mainProgram = "telepresence";
  };
}
