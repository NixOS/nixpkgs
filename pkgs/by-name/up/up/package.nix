{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "up";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "akavel";
    repo = "up";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d6FCJ9G9ytHhWQ5lXEtlmzclt3odS9e+Y1ry6EiIDsk=";
  };

  vendorHash = "sha256-PbOMUrKigCUuu5Hv3h0ZYSYezS+64DIZSubnQZ12HOE=";

  meta = {
    description = "Ultimate Plumber is a tool for writing Linux pipes with instant live preview";
    homepage = "https://github.com/akavel/up";
    maintainers = with lib.maintainers; [ ma27 ];
    license = lib.licenses.asl20;
    mainProgram = "up";
  };
})
