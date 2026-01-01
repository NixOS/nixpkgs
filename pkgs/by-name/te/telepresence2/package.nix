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
<<<<<<< HEAD
  version = "2.25.2";
=======
  version = "2.25.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7QLx+t8Y9r8iO53gtbeK3SOEhYN6NZTWzCe+bhWl3JA=";
=======
    hash = "sha256-Itj+tC5OclTXsRdJ6Rh4xQ1YwMSZTTdcRzpUQrmpC0M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  vendorHash = "sha256-Zroh9/FKG+wm8nX+t+TpJQeT2nFi8UrzxAWnNAaMt8Q=";
=======
  vendorHash = "sha256-iNvvFl05Q/6uXDSYyAijayXfvObmwh6aDR6XmFQkSHI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/telepresenceio/telepresence/v2/pkg/version.Version=${src.rev}"
  ];

  subPackages = [ "cmd/telepresence" ];

<<<<<<< HEAD
  meta = {
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    homepage = "https://telepresence.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    homepage = "https://telepresence.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mausch
      vilsol
      wrbbz
    ];
    mainProgram = "telepresence";
  };
}
