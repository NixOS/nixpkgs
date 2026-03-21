{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tfswitch";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-oaroJ02hHYxCFm5oS/IUSe00QH6n7G+LE/1tUO19TAI=";
  };

  vendorHash = "sha256-fF7iAN0sX0yMGIQ3MvH7jIzlHpfY8+uE1XlBi28Q5RU=";

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
