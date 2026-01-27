# https://github.com/apertium/packaging/blob/main/tools/udpipe/debian

{
  callPackage,
  lib,
  stdenv,
  fetchgit,
  testers,
  versionCheckHook,
  udpipe1,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "udpipe1";
  version = "1.3.1";

  src = fetchgit {
    url = "https://github.com/ufal/udpipe";
    rev = "da13c46cccc55fc0772ff221abbea3f798237115";
    sha256 = "NEqCXYeHmwPnEix+IyBn1zQnI1KtSIRe7s97bWBV4DQ=";
  };

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  sourceRoot = "${src.name}/src";

  enableParallelBuilding = true;

  buildPhase = ''
    make VERBOSE=1 MODE=release -j$NIX_BUILD_CORES exe server lib
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -v udpipe $out/bin
    cp -v rest_server/udpipe_server $out/bin
    cp -v libudpipe.a $out/lib/
  '';

  passthru.tests = {
    version = testers.testVersion { package = udpipe1; };
  };

  passthru.tests.run = callPackage ./test.nix { udpipe1 = finalAttrs.finalPackage; };

  meta = with lib; {
    description = "UDPipe: Trainable pipeline for tokenizing, tagging, lemmatizing and parsing Universal Treebanks and other CoNLL-U files";
    homepage = "https://github.com/ufal/udpipe";
    changelog = "https://github.com/ufal/udpipe/blob/${finalAttrs.version}/CHANGES.md";
    license = licenses.mpl20;
    maintainers = with lib.maintainers; [ unhammer ];
    mainProgram = "udpipe";
    platforms = platforms.all;
  };
})
