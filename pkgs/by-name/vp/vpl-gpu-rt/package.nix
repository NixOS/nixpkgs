{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libdrm,
  libva,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vpl-gpu-rt";
  version = "26.3.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "vpl-gpu-rt";
    rev = "intel-onevpl-${finalAttrs.version}";
    hash = "sha256-YNLgCpxz8rARPClzWN/w484LWOdfA+v8KUB3TiCbUxU=";
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
    changelog = "https://github.com/intel/vpl-gpu-rt/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      evanrichter
      pjungkamp
    ];
  };
})
