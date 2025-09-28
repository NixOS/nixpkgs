{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libdrm,
  libva,
}:

stdenv.mkDerivation rec {
  pname = "vpl-gpu-rt";
  version = "25.3.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "vpl-gpu-rt";
    rev = "intel-onevpl-${version}";
    hash = "sha256-tnRYP8mdG0bocdQTcpeJAGX+sHA52JuqeKazlkL2Y+0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libdrm
    libva
  ];

  meta = {
    description = "oneAPI Video Processing Library Intel GPU implementation";
    homepage = "https://github.com/intel/vpl-gpu-rt";
    changelog = "https://github.com/intel/vpl-gpu-rt/releases/tag/${src.rev}";
    license = [ lib.licenses.mit ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      evanrichter
      pjungkamp
    ];
  };
}
