{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "trdsql";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "trdsql";
    tag = "v${version}";
    hash = "sha256-MkjQAOIXnydEmOFnnYrvE2TF2I0GqSrSRUAjd+/hHwc=";
  };

  vendorHash = "sha256-PoIa58vdDPYGL9mjEeudRYqPfvvr3W+fX5c+NgRIoLg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/noborus/trdsql.Version=${version}"
  ];

  # macOS panic: open /etc/protocols: operation not permitted
  # vendor/modernc.org/libc/libc_darwin.go import vendor/modernc.org/libc/honnef.co/go/netdb
  # https://gitlab.com/cznic/libc/-/blob/v1.61.6/honnef.co/go/netdb/netdb.go#L697
  # https://gitlab.com/cznic/libc/-/blob/v1.61.6/honnef.co/go/netdb/netdb.go#L733
  # this two line read /etc/protocols and /etc/services, which is blocked by darwin sandbox
  doCheck = !stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";
  installCheckPhase = ''
    runHook preInstallCheck

    expected="1,(NULL),v"
    result=$(echo "1,,v" | $out/bin/trdsql -inull "" -onull "(NULL)" "SELECT * FROM -")
    if [[ "$result" != "$expected" ]]; then
      echo "Test gave '$result'. Expected: '$expected'"
      exit 1
    fi

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for execute SQL queries on CSV, LTSV, JSON, YAML and TBLN with various output formats";
    homepage = "https://github.com/noborus/trdsql";
    changelog = "https://github.com/noborus/trdsql/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "trdsql";
  };
}
