{
  lib,
  eggDerivation,
  fetchFromGitHub,
  chickenEggs,
}:

eggDerivation {
  src = fetchFromGitHub {
    owner = "corngood";
    repo = "egg2nix";
    rev = "chicken-5";
    sha256 = "1vfnhbcnyakywgjafhs0k5kpsdnrinzvdjxpz3fkwas1jsvxq3d1";
  };

  pname = "egg2nix";
  version = "c5-git";
  buildInputs = with chickenEggs; [
    args
    matchable
  ];

  meta = {
    description = "Generate nix-expression from CHICKEN scheme eggs";
    mainProgram = "egg2nix";
    homepage = "https://github.com/the-kenny/egg2nix";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ corngood ];
  };
}
