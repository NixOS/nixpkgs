{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fixDarwinDylibNames,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tlottie";
  version = "1.0.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dkaraush";
    repo = "tlottie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WtYyyf7AL+jtYY368X26PTnKSBUSZ9+IZjod/T5Oceg=";
  };

  cargoHash = "sha256-ZICtOSL3BxNSrgHYir+GGb8vCEYCHZhZAjZMOIwQYE0=";

  buildFeatures = [ "c-api" ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  checkFlags = [
    # Limit and budget tests that fail on Darwin due to allocator/budget margin differences
    "--skip=dos::renderer_rejects_generated_work_after_successful_parse"
    "--skip=dos::animated_repeater_product_stays_bounded"
    "--skip=dos::clipped_dashed_round_join_zigzag_stays_bounded"
    "--skip=dos::compounding_repeaters_are_rejected"
    "--skip=dos::nested_track_matte_target_surfaces_stay_bounded"
    "--skip=dos::renderer_rejects_large_canvas_before_allocating_fallback"
  ];

  postInstall = ''
    install -Dm644 include/tlottie.h -t "''${!outputInclude:?}/include"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust library for drawing Lottie animations";
    homepage = "https://github.com/dkaraush/tlottie";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
