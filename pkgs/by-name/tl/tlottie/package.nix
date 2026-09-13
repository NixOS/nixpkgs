{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tlottie";
  version = "0-unstable-2026-09-11";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dkaraush";
    repo = "tlottie";
    rev = "31f1b542f88e7b4be9a01e749920d857535fc715";
    hash = "sha256-JsRB0VfYTXgtgwape1i4TFeA7vFS3ckUu1Hr56KRe2w=";
  };

  cargoHash = "sha256-R/l5zMRB/2/a4Yf6toPBBvJ1SvebWsGeumwW9U6b7So=";

  buildFeatures = [ "c-api" ];

  checkFlags = [
    # called `Result::unwrap()` on an `Err` value: LimitExceeded(ParseMemory)
    "--skip=dos::renderer_rejects_generated_work_after_successful_parse"
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
