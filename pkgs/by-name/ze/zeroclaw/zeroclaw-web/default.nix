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

  npmDepsHash = "sha256-DVL9kov8y1Eh3BM2Rpw+KbTDL6/AvT/epknM2X/Gf3E=";

  # api-generated.ts is produced by `cargo web gen-api`, which requires the
  # compiled Rust gateway binary — unavailable during the web build.  The two
  # re-exported types are compile-time only (erased by Vite), so a minimal stub
  # is sufficient.  Re-check on every bump: if upstream starts committing
  # api-generated.ts or removes the import, this patch can be dropped.
  patches = [ ./add-api-generated-stub.patch ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
