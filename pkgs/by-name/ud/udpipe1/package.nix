# https://github.com/apertium/packaging/blob/main/tools/udpipe/debian
{
  callPackage,
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  versionCheckHook,
  udpipe1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udpipe1";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "ufal";
    repo = "udpipe";
    rev = "a0e72fcb1ba0d36998dc671db4350bbd159861b5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ekRuaQlNGv+7eFtwqbs6d6hy/b8uZpHq2ffcKPcre7U=";
  };

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  makeFlags = [
    "VERBOSE=1"
    "MODE=release"
  ];
  buildFlags = [
    "exe"
    "server"
    "lib"
  ];
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib}
    cp -v udpipe $out/bin
    cp -v rest_server/udpipe_server $out/bin
    cp -v libudpipe.a $out/lib/
    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion { package = udpipe1; };
    run = callPackage ./test.nix { udpipe1 = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Trainable pipeline for tokenizing, tagging, lemmatizing and parsing Universal Treebanks and other CoNLL-U files";
    homepage = "https://github.com/ufal/udpipe";
    changelog = "https://github.com/ufal/udpipe/blob/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ unhammer ];
    mainProgram = "udpipe";
    platforms = lib.platforms.all;
    badPlatforms = [ "aarch64-linux" ]; # until https://github.com/ufal/cpp_builtem/pull/2 is merged
  };
})
