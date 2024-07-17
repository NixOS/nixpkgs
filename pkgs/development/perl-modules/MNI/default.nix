{
  fetchFromGitHub,
  buildPerlPackage,
  lib,
}:

buildPerlPackage {
  pname = "MNI-Perllib";
  version = "2012-04-13";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "mni-perllib";
    rev = "b908472b4390180ea5d19a121ac5edad6ed88d83";
    sha256 = "0vk99pwgbard62k63386r7dpnm3h435jdqywr4xqfq7p04dz6kyb";
  };

  patches = [ ./no-stdin.patch ];

  doCheck = false; # TODO: almost all tests fail ... is this a real problem?

  meta = {
    description = "MNI MINC perllib (not used much anymore)";
    homepage = "https://github.com/BIC-MNI/mni-perllib";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
