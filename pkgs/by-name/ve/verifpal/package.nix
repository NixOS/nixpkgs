{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pigeon,
}:

buildGoModule (finalAttrs: {
  pname = "verifpal";
  version = "0.31.2";

  src = fetchFromGitHub {
    owner = "symbolicsoft";
    repo = "verifpal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k8SGCo36tk4Etg4jt0NDeEj1BmSYjaZZptNNnrOXs4E=";
  };

  vendorHash = "sha256-Vg375DBPvurRpwl918AGQU+wJGnB1tYisgch9FA+Y/g=";

  nativeBuildInputs = [ pigeon ];

  subPackages = [ "cmd/verifpal" ];

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ gpl3 ];
  };
})
