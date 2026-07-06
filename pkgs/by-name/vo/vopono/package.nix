{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vopono";
  version = "0.10.16";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-mZ2PHN1dBW++MZ3APV6sbPgrltcjzTyZvxbvvrsveo4=";
  };

  cargoHash = "sha256-jC3iANsDXdit9gAPs5k+rbUUL/J+lH9H4JGiEigMKiw=";

  meta = {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "vopono";
  };
})
