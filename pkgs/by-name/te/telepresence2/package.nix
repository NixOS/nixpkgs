{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  fuse3,
  macfuse-stubs,
  runCommand,
  jq,
  gnused,
  gawk,
  gnugrep,
}:

let
  k8sVersion = "v1.36.2";
  k8sDefsJson = fetchurl {
    url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/${k8sVersion}-standalone/_definitions.json";
    hash = "sha256-qemM3GqwmYDyO16Yel8R0OwfyDgYfvuS80fM847Y/WU=";
  };
in
buildGoModule rec {
  pname = "telepresence2";
  version = "2.31.2";

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = "v${version}";
    hash = "sha256-7COG0LwInqoX9a1SwJyXcF+ptGCKTYJz6wP9uN/CKZo=";
  };

  nativeBuildInputs = [
    jq
  ];

  # the fuseftp file system is linked into the binary and requires CGO (libfuse)
  # ref: https://github.com/telepresenceio/telepresence/blob/v2.31.2/build-aux/main.mk#L38-L43
  buildInputs = [
    # cgofuse uses the fuse2 header locations on darwin
    (if stdenv.hostPlatform.isDarwin then (macfuse-stubs.override { isFuse3 = false; }) else fuse3)
  ];

  # upstream builds against the FUSE 2 API by default; the vendored cgofuse
  # supports FUSE 3 behind this build tag
  tags = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "fuse3" ];

  preBuild = ''
    mkdir -p charts/telepresence-oss
    cp ${k8sDefsJson} charts/telepresence-oss/k8s-defs.json
  '';

  vendorHash = "sha256-5kqdZS5+1cp+DXb/zi4Yc7A38yZPZaOUvOccPKYjP98=";

  # required for the encoding/json/v2 and encoding/json/jsontext imports,
  # which are still experimental in Go 1.26
  # ref: https://github.com/telepresenceio/telepresence/blob/v2.31.2/build-aux/main.mk#L33
  env.GOEXPERIMENT = "jsonv2";

  # ldflags copied from Makefile
  # ref: https://github.com/telepresenceio/telepresence/blob/v2.31.2/build-aux/main.mk#L240-L243
  ldflags = [
    "-s"
    "-w"
    "-X=github.com/telepresenceio/telepresence/v2/pkg/version.Version=${src.rev}"
  ];

  preConfigure = ''
    HELM_VERSION=$(go mod edit -json | jq -r '.Require[] | select(.Path == "helm.sh/helm/v3") | .Version')
    ldflags="$ldflags -X github.com/telepresenceio/telepresence/v2/pkg/version.HelmVersion=$HELM_VERSION"
  '';

  # cgofuse hardcodes -I/usr/include/fuse3 for its #include <fuse.h>, and
  # loads libfuse at runtime via dlopen with a bare soname, which cannot be
  # resolved on NixOS; point it at the store path instead
  postConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace vendor/github.com/winfsp/cgofuse/fuse/host_cgo.go \
      --replace-fail "fuse.h" "fuse3/fuse.h" \
      --replace-fail '"libfuse3.so.3"' '"${lib.getLib fuse3}/lib/libfuse3.so.3"'
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
  };

  meta = {
    # requires CGO and dlopens libfuse at runtime
    broken = stdenv.hostPlatform.isStatic;
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
