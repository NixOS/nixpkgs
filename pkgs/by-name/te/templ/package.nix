{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "templ";
  version = "0.3.1020";

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "templ";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wv7qKZfnavz8lxfaOaIJJySNsXsjke1ADJuv2kgQOHE=";
  };

  vendorHash = "sha256-i4uDGZb3VZUvIyO2Tt53VR1Do/3OYtj6JccGoFnnlbs=";

  subPackages = [ "cmd/templ" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language for writing HTML user interfaces in Go";
    homepage = "https://github.com/a-h/templ";
    license = lib.licenses.mit;
    mainProgram = "templ";
    maintainers = with lib.maintainers; [ luleyleo ];
  };
})
