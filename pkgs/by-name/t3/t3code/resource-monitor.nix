{
  lib,
  ps,
  rustPlatform,
  stdenv,
  t3code-unwrapped,
}:

rustPlatform.buildRustPackage {
  pname = "t3code-resource-monitor";
  inherit (t3code-unwrapped) version src;

  sourceRoot = "${t3code-unwrapped.src.name}/native/resource-monitor";

  cargoHash = "sha256-QartZALjE2BxgfKcV3CJjtG6oSNE/Vcbz2ESx1UrRbk=";

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [ ps ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Use GNU date's syntax for formatting an epoch timestamp.
    substituteInPlace src/main.rs \
      --replace-fail '"-r",' '"-d",' \
      --replace-fail '&(row.start_time_micros / 1_000_000).to_string(),' \
                     '&format!("@{}", row.start_time_micros / 1_000_000),'
  '';

  meta = {
    description = "Native resource diagnostics sidecar for T3 Code";
    inherit (t3code-unwrapped.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    mainProgram = "t3-resource-monitor";
  };
}
