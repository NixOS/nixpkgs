{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  fuse,
  pkgs,
}:

let
  telepresenceAttrs = {
    owner = "telepresenceio";
    repo = "telepresence";
    version = "2.22.4";
    rev = "v${telepresenceAttrs.version}";
    srcHash = "sha256-ECuu6uMsY5vZVrMJknnd5IH0BZ2yVBTKIIC/Q8RARs8=";
    vendorHash = "sha256-+l+Dtyq+9u+Lc6yF++KnX2DixVVfPX+oFUn3lq6B/1U=";
    fileHash = "sha256-ECuu6uMsY5vZVrMJknnd5IH0BZ2yVBTKIIC/Q8RARs8=";
  };

  fetchFileFromGitHub =
    {
      owner,
      repo,
      rev,
      filePath,
      hash,
    }:
    let
      fetched = fetchFromGitHub {
        owner = owner;
        repo = repo;
        rev = rev;
        hash = hash;
      };
    in
    pkgs.runCommand "fetch-file" { inherit fetched; } ''
      mkdir -p $out
      cp ${fetched}/${filePath} $out/${filePath}
    '';

  telepresenceGoMod = fetchFileFromGitHub {
    owner = telepresenceAttrs.owner;
    repo = telepresenceAttrs.repo;
    rev = telepresenceAttrs.rev;
    filePath = "go.mod";
    hash = telepresenceAttrs.fileHash;
  };

  goModContents = builtins.readFile "${telepresenceGoMod}/go.mod";

  # Extract the k8s.io/client-go version using builtins.match
  # This regex looks for a line like: k8s.io/client-go v0.33.2
  k8sClientGoMatch = builtins.match "k8s\\.io/client-go[[:space:]]+v0\\.([0-9]+\\.[0-9]+\\.[0-9]+)" goModContents;

  # Derive K8S_VERSION by replacing v0.x.y with v1.x.y
  k8sVersion = if k8sClientGoMatch != null then "v1.${k8sClientGoMatch [ 1 ]}" else "v1.33.2";

  # Fetch the _definitions.json based on K8S_VERSION
  k8sDefsJson = fetchurl {
    url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/${k8sVersion}-standalone/_definitions.json";
    hash = "sha256-lU3mcjwwf7ZLek+5S6XnLS/qpPbcPAbwcWDjYf+8dYU=";
  };

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
  pname = telepresenceAttrs.repo;
  version = telepresenceAttrs.version;

  src = fetchFromGitHub {
    owner = telepresenceAttrs.owner;
    repo = telepresenceAttrs.repo;
    rev = telepresenceAttrs.rev;
    hash = telepresenceAttrs.srcHash;
  };

  propagatedBuildInputs = [
    fuseftp
  ];

  preBuild = ''
    cp ${fuseftp}/bin/main ./pkg/client/remotefs/fuseftp.bits

    mkdir -p charts/telepresence-oss

    cp ${k8sDefsJson} charts/telepresence-oss/k8s-defs.json

    export CGO_ENABLED=0
  '';

  vendorHash = telepresenceAttrs.vendorHash;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/telepresenceio/telepresence/v2/pkg/version.Version=${telepresenceAttrs.rev}"
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
