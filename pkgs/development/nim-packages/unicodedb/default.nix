<<<<<<< HEAD
{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage (finalAttrs: {
  pname = "unicodedb";
  version = "0.12.0";
  src = fetchFromGitHub {
    owner = "nitely";
    repo = "nim-unicodedb";
    rev = finalAttrs.version;
    hash = "sha256-vtksdRTWH/Fjp1z8KSFGjgn1SRUxtUZwlOa+vMuB53A=";
  };
  meta = finalAttrs.src.meta // {
    description = "Unicode Character Database (UCD, tr44) for Nim";
    homepage = "https://github.com/nitely/nim-unicodedb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
=======
{ fetchFromGitHub }:

fetchFromGitHub {
  owner = "nitely";
  repo = "nim-unicodedb";
  rev = "v0.9.0";
  sha256 = "06j8d0bjbpv1iibqlmrac4qb61ggv17hvh6nv4pbccqk1rlpxhsq";
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
