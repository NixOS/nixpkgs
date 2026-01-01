{
  fetchurl,
  gitUpdater,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "rubygems";
  version = "3.7.2";

  src = fetchurl {
    url = "https://rubygems.org/rubygems/rubygems-${version}.tgz";
    hash = "sha256-7+zgEiWlMvS1LPh2TSCgDg0p7W+Fsz2TAt9IlqkPpas=";
  };

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

<<<<<<< HEAD
  meta = {
    description = "Package management framework for Ruby";
    changelog = "https://github.com/rubygems/rubygems/blob/v${version}/CHANGELOG.md";
    homepage = "https://rubygems.org/";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Package management framework for Ruby";
    changelog = "https://github.com/rubygems/rubygems/blob/v${version}/CHANGELOG.md";
    homepage = "https://rubygems.org/";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mit # or
      ruby
    ];
    mainProgram = "gem";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ zimbatm ];
=======
    maintainers = with maintainers; [ zimbatm ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
