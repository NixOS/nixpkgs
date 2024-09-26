{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  meson,
  cmake,
  ninja,
  glm,
  doctest,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "wf-touch";
  version = "0-unstable-2024-04-24";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-touch";
    rev = "caa156921c6be1dff9c2ccd851330c96de7928bf";
    hash = "sha256-sPFvAtsZhnxFCod3WYzYcz5UqziojDWhWtQBrILLBbo=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    cmake
    ninja
  ];

  buildInputs = [ doctest ];

  propagatedBuildInputs = [ glm ];

  mesonBuildType = "release";

  # Patch wf-touch to generate pkgconfig
  patches = fetchpatch {
    url = "https://raw.githubusercontent.com/horriblename/hyprgrass/736119f828eecaed2deaae1d6ff1f50d6dabaaba/nix/wf-touch.patch";
    hash = "sha256-3YK5YnO0NCwshs1reJFjJ9tIEhTNSS0fPWUDFo3XA3s=";
  };

  outputs = [
    "out"
    "dev"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Touchscreen gesture library";
    homepage = "https://github.com/WayfireWM/wf-touch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.unix;
  };
}
