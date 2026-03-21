{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  libv4l,
  fltk,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "image-acquisition";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "Andy1978";
    repo = "octave-image-acquisition";
    tag = "image-acquisition-${version}";
    sha256 = "sha256-vS1i0PNAyfkxuMSfm+OGvFXkpbD4H6VJrs4eb+LxYBA=";
  };

  buildInputs = [
    fltk
  ];

  propagatedBuildInputs = [
    libv4l
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "image-acquisition-(.*)"
    ];
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/image-acquisition/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Functions to capture images from connected devices";
    longDescription = ''
      The Octave-forge Image Aquisition package provides functions to
      capture images from connected devices. Currently only v4l2 is supported.
    '';
  };
}
