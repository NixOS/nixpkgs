{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "triforce-lv2";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "chadmed";
    repo = "triforce";
    rev = version;
    hash = "sha256-f4i0S6UaVfs1CUeQRqo22PRgMNwYDNoMunHidI1XzBk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2FC6wlFJkQryA/bcjF0GjrMQVb8hlUY+muFqPqShWss=";

  installPhase = ''
    export LIBDIR=$out/lib
    mkdir -p $LIBDIR

    make
    make install
  '';

  meta = with lib; {
    homepage = "https://github.com/chadmed/triforce";
    description = "Minimum Variance Distortionless Response adaptive beamformer for the microphone array found in some Apple Silicon laptops";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yuka ];
    platforms = platforms.linux;
  };
}
