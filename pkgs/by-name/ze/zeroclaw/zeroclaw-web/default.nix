{
  buildNpmPackage,
  src,
  version,
  npmDepsHash,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = "zeroclaw-web";
  inherit src version npmDepsHash;

  sourceRoot = "${finalAttrs.src.name}/web";

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
