{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tfswitch";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = "v${version}";
    sha256 = "sha256-zmGJiwdESf+3yXM7W64iSy38lADZmA03dI1yhtv9H28=";
  };

  vendorHash = "sha256-paJC46AJRaB5RieKs6wZYzshxAp8e8MvCatGsN8E4Io=";

  # Disable tests since it requires network access and relies on the
  # presence of release.hashicorp.com
  doCheck = false;

  postInstall = ''
    # The binary is named tfswitch
    mv $out/bin/terraform-switcher $out/bin/tfswitch
  '';

  meta = with lib; {
    description = "A command line tool to switch between different versions of terraform";
    mainProgram = "tfswitch";
    homepage = "https://github.com/warrensbox/terraform-switcher";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
