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
  version = "25.2.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "vpl-gpu-rt";
    rev = "intel-onevpl-${version}";
    hash = "sha256-59OG/1tS4SiPZk3ep508m/ULLMU7fJ7Bj9tYe9Do5AY=";
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
