{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tfswitch";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = "v${version}";
    sha256 = "sha256-c1ueznf3ihsZeLmhD35NZ3pvK79LaonIymu2/2KwbZM=";
  };

  vendorHash = "sha256-MF+P+t+8xVRB4AicuVSqs1VEmBBo180bz2IdHi58vWc=";

  # Disable tests since it requires network access and relies on the
  # presence of release.hashicorp.com
  doCheck = false;

  postInstall = ''
    # The binary is named tfswitch
    mv $out/bin/terraform-switcher $out/bin/tfswitch
  '';

  meta = with lib; {
    description = "Command line tool to switch between different versions of terraform";
    mainProgram = "tfswitch";
    homepage = "https://github.com/warrensbox/terraform-switcher";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
