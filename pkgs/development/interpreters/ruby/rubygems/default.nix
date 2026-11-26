{
  fetchurl,
  gitUpdater,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rubygems";
  version = "3.7.2";

  src = fetchurl {
    url = "https://rubygems.org/rubygems/rubygems-${finalAttrs.version}.tgz";
    hash = "sha256-7+zgEiWlMvS1LPh2TSCgDg0p7W+Fsz2TAt9IlqkPpas=";
  };

  strictDeps = true;

  patches = [
    ./0001-add-post-extract-hook.patch
    ./0002-binaries-with-env-shebang.patch
    ./0003-gem-install-default-to-user.patch
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

  __structuredAttrs = true;

  meta = {
    description = "Package management framework for Ruby";
    changelog = "https://github.com/rubygems/rubygems/blob/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://rubygems.org/";
    license =
      with lib.licenses;
      OR [
        mit
        ruby
      ];
    mainProgram = "gem";
    maintainers = with lib.maintainers; [ zimbatm ];
  };
})
