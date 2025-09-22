{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tcat";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "rsc";
    repo = "tcat";
    rev = "v${version}";
    sha256 = "1szzfz5xsx9l8gjikfncgp86hydzpvsi0y5zvikd621xkp7g7l21";
  };
  vendorHash = null;
  subPackages = ".";

  meta = with lib; {
    description = "Table cat";
    homepage = "https://github.com/rsc/tcat";
    maintainers = with maintainers; [ mmlb ];
    license = licenses.bsd3;
    mainProgram = "tcat";
  };
}
