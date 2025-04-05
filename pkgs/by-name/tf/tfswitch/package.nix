{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tfswitch";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = "v${version}";
    sha256 = "sha256-5Zyu0SLF+xjemFKInzRKCcDZs72gwAJN7bacO+5StMg=";
  };

  vendorHash = "sha256-EjbS+1osM6Qauoi95JHLOdxeLOz0Jgz6ZaTFtfs6IgM=";

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
