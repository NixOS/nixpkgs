{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  control,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "signal";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-signal";
    tag = "${version}";
    sha256 = "sha256-4E57x2hweO1TfpjBRRvsyQA/o83XJLrRKa5vqUA0t3s=";
  };

  requiredOctavePackages = [
    control
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/signal/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Signal processing tools, including filtering, windowing and display functions";
  };
}
