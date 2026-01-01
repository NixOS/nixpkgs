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

<<<<<<< HEAD
  meta = {
    description = "Table cat";
    homepage = "https://github.com/rsc/tcat";
    maintainers = with lib.maintainers; [ mmlb ];
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Table cat";
    homepage = "https://github.com/rsc/tcat";
    maintainers = with maintainers; [ mmlb ];
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "tcat";
  };
}
