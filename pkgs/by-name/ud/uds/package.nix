{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  stdenv,
  go,
  git,
}:
buildGoModule rec {
  pname = "uds";
  version = "0.27.6";

  meta = {
    description = "A secure runtime platform for National Security. https://uds.defenseunicorns.com/";
    homepage = "https://uds.defenseunicorns.com/";
    mainProgram = "uds";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ realnedsanders ];
  };

  src = fetchFromGitHub {
    owner = "defenseunicorns";
    repo = "uds-cli";
    tag = "v${version}";
    hash = "sha256-DVkm1INAiTKscjlJ9k2ysdIMbSY4qqxVDz4zZEk3BZ4=";
  };

  vendorHash = "sha256-EWDX01j7NFsX/oNlxy/JB2sm5C/NHzvRqYABXlkl3BQ=";

  doCheck = false;

  # this accepts a regex of test fn names to skip.
  # checkFlags =
  #   let
  #     # Skip e2e tests
  #     skippedTests = [
  #       ""
  #     ];
  #   in
  #   [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  env = {
    CGO_ENABLED = if stdenv.hostPlatform.isDarwin then "1" else "0";
  };

  ldflags =
    let
      # Get versions from go.sum file
      goSum = builtins.readFile "${src}/go.sum";

      ifNotNull = x: if x != null then x else "null";

      getGoVersion =
        name:
        let
          goSumLines = lib.splitString "\n" goSum;
          matchLine = line: builtins.match "^${name} v([0-9.]+).*$" line;
          found = lib.findFirst (line: matchLine line != null) null goSumLines;
          m = if found != null then matchLine found else null;
        in
        if m != null && builtins.isList m && m != [ ] then builtins.elemAt m 0 else null;

      # Extract k8s version components
      k8sClientVersion = getGoVersion "k8s.io/client-go";
      k8sMajor = builtins.toString (
        1 + lib.strings.toInt (builtins.elemAt (builtins.splitVersion k8sClientVersion) 0)
      );
      k8sMinor = builtins.elemAt (builtins.splitVersion k8sClientVersion) 1;
      k8sPatch = builtins.elemAt (builtins.splitVersion k8sClientVersion) 2;
      k8sVersion = "${k8sMajor}.${k8sMinor}.${k8sPatch}";
    in
    [
      "-s"
      "-w"
      "-X github.com/defenseunicorns/uds-cli/src/config.CLIVersion=${version}"
      "-X helm.sh/helm/v3/pkg/lint/rules.k8sVersionMajor=${k8sMajor}"
      "-X helm.sh/helm/v3/pkg/lint/rules.k8sVersionMinor=${k8sMinor}"
      "-X helm.sh/helm/v3/pkg/chartutil.k8sVersionMajor=${k8sMajor}"
      "-X helm.sh/helm/v3/pkg/chartutil.k8sVersionMinor=${k8sMinor}"
      "-X github.com/zarf-dev/zarf/src/config.ActionsCommandZarfPrefix=zarf"
      "-X github.com/derailed/k9s/cmd.version=${getGoVersion "github.com/derailed/k9s"}"
      "-X github.com/google/go-containerregistry/cmd/crane/cmd.Version=${getGoVersion "github.com/google/go-containerregistry"}"
      "-X github.com/zarf-dev/zarf/src/cmd/tools.syftVersion=${getGoVersion "github.com/anchore/syft"}"
      "-X github.com/zarf-dev/zarf/src/cmd/tools.archiverVersion=${getGoVersion "github.com/mholt/archives"}"
      "-X github.com/zarf-dev/zarf/src/cmd/tools.helmVersion=${getGoVersion "helm.sh/helm/v3"}"
    ];
}
