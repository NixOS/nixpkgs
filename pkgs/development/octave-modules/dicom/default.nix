{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  gdcm,
  autoreconfHook,
  pkg-config,
  cmake,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "dicom";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-dicom";
    tag = "release-${version}";
    sha256 = "sha256-6FcHxNUOTvSzYqknD89G3IyKVQs/dH+heoA/5Sx4lyg=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    cmake
  ];

  propagatedBuildInputs = [
    gdcm
  ];

  dontUseCmakeConfigure = true;

  preAutoreconf = ''
    pushd src
    # Removed these so autoreconf actually fires for our environment.
    rm config.*
  '';
  postAutoreconf = ''
    popd
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=release-(.*)" ]; };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/dicom/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Digital communications in medicine (DICOM) file io";
  };
}
