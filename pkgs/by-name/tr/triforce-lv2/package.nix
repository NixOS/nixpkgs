{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "triforce-lv2";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "chadmed";
    repo = "triforce";
    rev = version;
    hash = "sha256-qEN/KQup4bpHCt8GpsiJ2wfUQxM8F9DWuGHEJiBVfQA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mTvxPS1OpGhPqKzMC0XSJZaNEFajlEVkG3o1vk3+LNM=";

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
