{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tfswitch";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-TpE0HX/2fGv17o1mwkyuWndclbydUBC6EKy6uFC5VdM=";
  };

  vendorHash = "sha256-NxPqXpXCSHqgUJSC4/2R/ImqwNX9e+qNUU6g9n2SWBo=";

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
