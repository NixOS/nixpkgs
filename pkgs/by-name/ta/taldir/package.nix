{
  fetchgit,
  lib,
  recutils,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "taldir";
  version = "1.0.5";

  src = fetchgit {
    url = "https://git.taler.net/taldir.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZKNkMV0IV6E+yCQeabGXpIQclx1S4YEgFn4whGXTaks=";
  };

  vendorHash = "sha256-QCwakJTpRP7VT69EzQeInCCGBuNu3WsNCytnQcBdKQw=";

  nativeBuildInputs = [
    recutils
  ];

  # From Makefile
  preBuild = ''
    mkdir -p internal/gana

    pushd third_party/gana/gnu-taler-error-codes
    make taler_error_codes.go
    popd

    cp third_party/gana/gnu-taler-error-codes/taler_error_codes.go internal/gana/
  '';

  subPackages = [
    "cmd/taldir-cli"
    "cmd/taldir-server"
  ];

  # dial error (dial tcp [::1]:5432: connect: connection refused)
  doCheck = false;

  meta = {
    homepage = "https://git.taler.net/taldir.git";
    description = "Directory service to resolve wallet mailboxes by messenger addresses";
    teams = with lib.teams; [ ngi ];
    # themadbit will maintain after being added to maintainers
    maintainers = with lib.maintainers; [ ];
    license = lib.licenses.agpl3Plus;
  };
})
