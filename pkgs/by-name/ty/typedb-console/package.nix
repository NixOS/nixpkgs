{
  lib,
  rustPlatform,
  fetchgit,
  protobuf,
  testers,
}:
let
  # Full protocol tree (same subdirectory-vendoring reason as the server
  # package): the protocol build script compiles ../../proto/*.proto.
  protocolFull = fetchgit {
    url = "https://github.com/typedb/typedb-protocol.git";
    rev = "cef7aaf8144b7534f47c9ca82db3fefc3b81d623";
    hash = "sha256-6pSzWHMnTDtZm0jKgivikP8EWkD69ABTlsau8mf6tFg=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typedb-console";
  version = "3.13.0";

  # fetchgit (not fetchFromGitHub): the repo's .gitattributes forces CRLF
  # line endings on *.bat in GitHub-generated tarballs, which would change
  # the nar hash depending on archive generation. A pinned-rev clone is
  # byte-stable.
  src = fetchgit {
    url = "https://github.com/typedb/typedb-tools.git";
    rev = "27547be8e39021dffd84c393185f4efcd049074c";
    hash = "sha256-WOp5yKCK2hayW6NPKdJNLx+o+IiBBKAkR94AGdDbTCk=";
  };

  # Patched-lock vendor hash, harvested from the fixed-output mismatch on
  # the reviewed revision. The protocol git dep needs its full tree (see
  # the server package); the rest is complete under subtree vendoring.
  cargoHash = "sha256-A1WntvJhv23aqovtSTx9XQ4EwUy4TwdjY/ZM1mfBUW4=";

  nativeBuildInputs = [ protobuf ];
  PROTOC = "${protobuf}/bin/protoc";

  # Upstream console-3.13.0 tag ships a Cargo.lock pinning typedb-driver
  # 3.12.0 while the manifests require 3.12.3, so --locked resolution fails
  # on the pristine tag. Refresh it with the canonical `cargo update`
  # resolution (same change as typedb/typedb-tools#372); drop the patch
  # once a release tag carries a current lock. cargoPatches (not patches)
  # so the refresh also applies inside the vendor derivation.
  cargoPatches = [ ./lock-refresh.patch ];

  # Same full-tree protocol patch as the server package (its build script
  # reaches ../../proto). The lock updates offline; unit scope only, since
  # the repo's integration tests need a running server.
  postPatch = ''
    cat >> Cargo.toml <<EOF
    [patch."https://github.com/typedb/typedb-protocol"]
    typedb-protocol = { path = "${protocolFull}/grpc/rust" }
    EOF
  '';

  doCheck = true;
  # Bin unit tests only: the package has no lib target, and the repo's
  # integration tests need a running server.
  checkFlags = [
    "--workspace"
    "--bins"
  ];

  # This package ships the Console only (the task's "client"): the sibling
  # loader and typeql-check binaries stay in their own future packages.
  postInstall = ''
    rm -f $out/bin/typedb-loader $out/bin/typeql-check
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "typedb-console --version";
    version = finalAttrs.version;
  };

  meta = {
    description = "Command-line client (Console) for TypeDB";
    homepage = "https://typedb.com";
    license = lib.licenses.mpl20;
    mainProgram = "typedb-console";
    maintainers = with lib.maintainers; [ caniko ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
