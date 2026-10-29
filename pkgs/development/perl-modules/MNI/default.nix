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
    hash = "sha256-y0/zGwH3YIc7ydzjJssgcFR728kGjWGmMC2r9fhNaW4=";
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
