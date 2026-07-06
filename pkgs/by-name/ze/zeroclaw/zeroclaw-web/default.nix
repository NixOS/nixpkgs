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

  npmDepsHash = "sha256-mwi93ZgXxb3xQnPPQHesR8YxQOxH8YaKBLGi/nEM8D4=";

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
