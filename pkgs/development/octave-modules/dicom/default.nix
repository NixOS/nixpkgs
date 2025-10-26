{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  gdcm,
  cmake,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "dicom";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-dicom";
    tag = "release-${version}";
    sha256 = "sha256-NNdcnIeHXDRmZZp0WvwGtfMJ4BSR6+aK6FVS0BG51U8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    gdcm
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=release-(.*)" ]; };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/dicom/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Digital communications in medicine (DICOM) file io";
  };
}
