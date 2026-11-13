{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ttfx";
  version = "0.5.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "ttfx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/cECljrthspJsg6fgWMm4QIv8V3FJLuP/pbZoRKFVAc=";
  };

  cargoHash = "sha256-xSv2a0Q1biE20cOHkSOADxFfRNYKH/1MNCA03hQX9pE=";

  # glibc picks its libm variant per CPU, so the bit-exact easing goldens drift by
  # an ulp on some builders; upstream: omacom/ttfx#58 (issue omacom/ttfx#56)
  checkFlags = lib.optionals stdenv.hostPlatform.isGnu [
    "--skip=easing_matches_python_bit_exactly"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal text effects engine as a standalone CLI";
    homepage = "https://github.com/omacom/ttfx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "ttfx";
  };
})
