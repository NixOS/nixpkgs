{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unpackelf";
  version = "2022.11.09";

  src = fetchFromGitHub {
    owner = "osm0sis";
    repo = "unpackelf";
    tag = finalAttrs.version;
    hash = "sha256-uAt4qpctQPGyXFLtRqTBiCXahoA+/b5rYZCjIh8N+QU=";
  };

  strictDeps = true;

  # Unstream has an install target, but installs unpackelf as `$out/bin`
  # instead of `$out/bin/unpackelf`
  installPhase = ''
    runHook preInstall
    install -Dm555 unpackelf -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/osm0sis/unpackelf";
    description = "Tool to unpack Sony ELF kernel format image variants";
    # No license specified in the repository
    license = lib.licenses.free;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "unpackelf";
  };
})
