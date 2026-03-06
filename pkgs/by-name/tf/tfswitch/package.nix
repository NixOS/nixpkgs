{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tfswitch";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-PIGKrDeavUL7J44nLhHRHw/R3FBA6aKn2HJxtiCWZuQ=";
  };

  vendorHash = "sha256-DywtJ/XXHLATM216wNM999zfqT0qndWnlBrUTreTa7Y=";

  # Disable tests since it requires network access and relies on the
  # presence of release.hashicorp.com
  doCheck = false;

  postInstall = ''
    # The binary is named tfswitch
    mv $out/bin/terraform-switcher $out/bin/tfswitch
  '';

  meta = {
    description = "Command line tool to switch between different versions of terraform";
    mainProgram = "tfswitch";
    homepage = "https://github.com/warrensbox/terraform-switcher";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psibi ];
  };
})
