{
  lib,
  rustPlatform,
  fetchgit,
  testers,
}:
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

  # Discovery placeholder: the pristine-tag vendor hash. The patched lock
  # changes vendor content, so this run harvests the patched vendor hash
  # from the fixed-output mismatch message (sanctioned hash discovery).
  cargoHash = "sha256-K8InTOFLJwYZKaW98iz/BAJkXPDSl11XIqYeEO6gqpQ=";

  # Upstream console-3.13.0 tag ships a Cargo.lock pinning typedb-driver
  # 3.12.0 while the manifests require 3.12.3, so --locked resolution fails
  # on the pristine tag. Refresh it with the canonical `cargo update`
  # resolution (same change as typedb/typedb-tools#372); drop the patch
  # once a release tag carries a current lock. cargoPatches (not patches)
  # so the refresh also applies inside the vendor derivation.
  cargoPatches = [ ./lock-refresh.patch ];

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
