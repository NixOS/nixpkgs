{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "todoist";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "sha256-mdh+DOqlxcAqWIxEiKXmtvlsaaRCnRWEvrn56IFhBwk=";
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
