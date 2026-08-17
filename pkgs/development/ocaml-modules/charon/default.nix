{
  lib,
  buildDunePackage,
  fetchFromGitHub,

  # propagatedBuildInputs,
  easy_logging,
  name_matcher_parser,
  ppx_deriving,
  unionFind,
  visitors,
  yojson,

  nix-update-script,
}:

buildDunePackage (finalAttrs: {
  pname = "charon";
  version = "2026.07.01";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AeneasVerif";
    repo = "charon";
    tag = "nightly-${finalAttrs.version}";
    hash = "sha256-luHH/Bj5MfeIrjkxBP4sCNa4mQZwJLcFhsuWaJQP5E0=";
  };

  propagatedBuildInputs = [
    easy_logging
    name_matcher_parser
    ppx_deriving
    unionFind
    visitors
    yojson
  ];

  # The charon-ml test suite requires pre-generated `.llbc` fixtures produced by
  # running the (Rust) charon binary, which are not part of the OCaml source
  # distribution, so the tests cannot run here.
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };

  meta = {
    description = "Analyze Rust crates without touching compiler internals";
    homepage = "https://github.com/AeneasVerif/charon";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
  };
})
