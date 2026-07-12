{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "versus";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "INFURA";
    repo = "versus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jX2HRdrLwDjnrUofRzmsSFLMbiPh0a1DPv1tzl+StUg=";
  };

  vendorHash = "sha256-e116ZXofSnD7+5f8xdBjpMYdeUhGPVTLfaxnhhqTIrQ=";

  meta = {
    description = "Benchmark multiple API endpoints against each other";
    homepage = "https://github.com/INFURA/versus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mmahut ];
    mainProgram = "versus";
  };
})
