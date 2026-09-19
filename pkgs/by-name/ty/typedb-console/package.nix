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

  cargoHash = "sha256-G0+g5NJ6SJo3N5rsTVu7KQfCDQoz9NfENN4jeWH2MJI=";

  # Upstream console-3.13.0 tag ships a Cargo.lock pinning typedb-driver
  # 3.12.0 while the manifests require 3.12.3, so --locked resolution fails
  # on the pristine tag. This is the same one-line refresh as upstream PR
  # <typedb-tools lock refresh>; drop it once a release tag carries a
  # current lock.
  postPatch = ''
    substituteInPlace Cargo.lock \
      --replace-fail 'git+https://github.com/typedb/typedb-driver?tag=3.12.0#39db6731ba004c8c959cdb3b69a0f05a10793235' \
      'git+https://github.com/typedb/typedb-driver?tag=3.12.3#f487d961884010ff305d4395c41e80fa620251c6'
  '';

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
