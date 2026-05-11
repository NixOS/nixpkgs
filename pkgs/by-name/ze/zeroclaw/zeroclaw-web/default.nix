{
  buildNpmPackage,
  src,
  version,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = "zeroclaw-web";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/web";

  npmDepsHash = "sha256-4+raDJ7+w+RpdeZs2PJL10IWzfoT5B3EpOxsLUnlrRc=";

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
