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

  npmDepsHash = "sha256-RMiFoPj4cbUYONURsCp4FrNuy9bR1eRWqgAnACrVXsI=";

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
