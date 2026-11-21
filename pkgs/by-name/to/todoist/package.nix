{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "todoist";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hTZELPYcsCgW3zEc07PeXyNZTRsf5lgFA53XlEdQek0=";
  };

  vendorHash = "sha256-W+w8+4JP12GEJJyhetQIuPzFIIGhTh1r/nslLw+dnIc=";

  doCheck = false;

  meta = {
    homepage = "https://github.com/sachaos/todoist";
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    mainProgram = "todoist";
  };
})
