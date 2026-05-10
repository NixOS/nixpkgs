{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tfswitch";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mwseK++lsiN2oPkLnXJm4M5sHybzPI3fCPtn1Ft+dkE=";
  };

  vendorHash = "sha256-jR8zutVetlZ3WBSPxAg2ZdppqDf9+E/yuvsTeHHHtfs=";

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
