{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "todoist";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "sha256-+UECYUozca7PKKiTrmPAobSF0y6xnWYCGaChk9bwANg=";
  };

  vendorHash = "sha256-fWFFWFVnLtZivlqMRIi6TjvticiKlyXF2Bx9Munos8M=";

  doCheck = false;

  meta = {
    homepage = "https://github.com/sachaos/todoist";
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    mainProgram = "todoist";
  };
}
