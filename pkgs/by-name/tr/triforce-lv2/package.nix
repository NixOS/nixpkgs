{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "triforce-lv2";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "chadmed";
    repo = "triforce";
    rev = version;
    hash = "sha256-Y9ufUADhpT3NPj/OfhQ7xJoBqoOkPkVFA0TvUwCubrU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qJ9DYlYr0CsnRAQ8DtiimWdf/kyTOLQOiqb2N747CE4=";

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
