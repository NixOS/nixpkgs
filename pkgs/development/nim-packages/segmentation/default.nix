<<<<<<< HEAD
{ lib, buildNimPackage, fetchFromGitHub, unicodedb }:

buildNimPackage (finalAttrs: {
  pname = "segmentation";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "nitely";
    repo = "nim-segmentation";
    rev = "v${finalAttrs.version}";
    sha256 = "007bkx8dwy8n340zbp6wyqfsq9bh6q5ykav1ywdlwykyp1n909bh";
  };
  propagatedBuildInputs = [ unicodedb ];
  meta = finalAttrs.src.meta // {
    description = "Unicode text segmentation (tr29)";
    homepage = "https://github.com/nitely/nim-segmentation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
=======
{ fetchFromGitHub }:

fetchFromGitHub {
  owner = "nitely";
  repo = "nim-segmentation";
  rev = "v0.1.0";
  sha256 = "007bkx8dwy8n340zbp6wyqfsq9bh6q5ykav1ywdlwykyp1n909bh";
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
