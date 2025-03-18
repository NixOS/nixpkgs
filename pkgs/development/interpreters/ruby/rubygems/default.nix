{
  fetchurl,
  gitUpdater,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "rubygems";
  version = "3.5.16";

  src = fetchurl {
    url = "https://rubygems.org/rubygems/rubygems-${version}.tgz";
    hash = "sha256-f9EN6eXpMzIbYrjxGUJWrmRwO6JUHKuR7DEkSgGNkBI=";
  };

  patches = [
    ./0001-add-post-extract-hook.patch
    ./0002-binaries-with-env-shebang.patch
    ./0003-gem-install-default-to-user.patch
    ./0004-delete-binstub-lock-file.patch
  ];

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/rubygems/rubygems.git";
    rev-prefix = "v";
    ignoredVersions = "(pre|alpha|beta|rc|bundler).*";
  };

  meta = with lib; {
    description = "Package management framework for Ruby";
    changelog = "https://github.com/rubygems/rubygems/blob/v${version}/CHANGELOG.md";
    homepage = "https://rubygems.org/";
    license = with licenses; [ mit /* or */ ruby ];
    mainProgram = "gem";
    maintainers = with maintainers; [ zimbatm ];
  };
}
