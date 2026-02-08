{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  fuse,
  runCommand,
  jq,
  gnused,
  gawk,
  gnugrep,
}:

let
  fuseftpVersion = "0.6.9";
  fuseftp = buildGoModule rec {
    pname = "go-fuseftp";
    version = fuseftpVersion;

    src = fetchFromGitHub {
      owner = "datawire";
      repo = "go-fuseftp";
      rev = "v${version}";
      hash = "sha256-iJTVcOsaDICQWqIsMTHWg/MDb++ZIfKnnAPrcumcRWk=";
    };

    vendorHash = "sha256-ZQUlgrC80gwIGTepNXI67Y9SYtarey3Y63eCqZAXXao=";

    buildInputs = [ fuse ];

    ldflags = [
      "-s"
      "-w"
    ];

    subPackages = [ "pkg/main" ];
  };

  k8sVersion = "v1.34.2";
  k8sDefsJson = fetchurl {
    url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/${k8sVersion}-standalone/_definitions.json";
    hash = "sha256-IMEXD8MeTgAhBn6dnElp7uKtVLv4UcuDI51pQ4o953Q=";
  };
in
buildGoModule rec {
  pname = "telepresence2";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = "v${version}";
    hash = "sha256-/WFTOFThqnUDCTkTTTj9Y6x5iaucH1H5/10mZGcyvQM=";
  };

  propagatedBuildInputs = [
    fuseftp
  ];

  nativeBuildInputs = [
    jq
  ];

  # telepresence depends on fuseftp existing as a built binary, as it gets embedded
  # CGO gets disabled to match their build process as that is how it's done upstream
  preBuild = ''
    cp ${fuseftp}/bin/main ./pkg/client/remotefs/fuseftp.bits

    mkdir -p charts/telepresence-oss
    cp ${k8sDefsJson} charts/telepresence-oss/k8s-defs.json

    export CGO_ENABLED=0
  '';

  vendorHash = "sha256-t7gQhMcB2T/hL6m+nH7G2ePiAUPCTtpKScfjB44QQCQ=";

  # ldflags copied from Makefile
  # ref: https://github.com/telepresenceio/telepresence/blob/7a2b9f553fb51ef252df957916c7b831bd65c1ce/build-aux/main.mk#L250-L251
  ldflags = [
    "-s"
    "-w"
    "-X=github.com/telepresenceio/telepresence/v2/pkg/version.Version=${src.rev}"
  ];

  preConfigure = ''
    HELM_VERSION=$(go mod edit -json | jq -r '.Require[] | select(.Path == "helm.sh/helm/v3") | .Version')
    ldflags="$ldflags -X github.com/telepresenceio/telepresence/v2/pkg/version.HelmVersion=$HELM_VERSION"
  '';

  subPackages = [ "cmd/telepresence" ];

  passthru.tests = {
    k8s-version-matches =
      runCommand "telepresence2-k8s-version-test"
        {
          nativeBuildInputs = [
            gnugrep
            gnused
            gawk
          ];
        }
        ''
          # ref: https://github.com/telepresenceio/telepresence/blob/7a2b9f553fb51ef252df957916c7b831bd65c1ce/build-aux/main.mk#L545
          actual_version=$(grep 'k8s.io/client-go' ${src}/go.mod | awk '{print $2}' | sed -e 's/v0\./v1./')
          expected_version="${k8sVersion}"

          if [ "$actual_version" != "$expected_version" ]; then
            echo "FAIL: k8s version mismatch in telepresence2" >&2
            echo "  Hardcoded in Nix: $expected_version" >&2
            echo "  Found in go.mod:  $actual_version" >&2
            echo "  Update k8sVersion variable & hash in telepresence2 package" >&2
            exit 1
          fi

          echo "PASS: k8s version $actual_version matches" | tee $out
        '';
    fuseftp-version-matches =
      runCommand "telepresence2-fuseftp-version-test"
        {
          nativeBuildInputs = [
            gnugrep
            gawk
          ];
        }
        ''
          actual_version=$(grep 'github.com/telepresenceio/go-fuseftp/rpc' ${src}/go.mod | awk '{print $2}')
          expected_version="v${fuseftpVersion}"

          if [ "$actual_version" != "$expected_version" ]; then
            echo "FAIL: fuseftp version mismatch in telepresence2" >&2
            echo "  Hardcoded in Nix: $expected_version" >&2
            echo "  Found in go.mod:  $actual_version" >&2
            echo "  Update fuseftpVersion variable & hash in telepresence2 package" >&2
            exit 1
          fi

          echo "PASS: fuseftp version $actual_version matches" | tee $out
        '';
  };

  meta = {
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    homepage = "https://telepresence.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mausch
      vilsol
      wrbbz
      thesn
    ];
    mainProgram = "telepresence";
  };
}
