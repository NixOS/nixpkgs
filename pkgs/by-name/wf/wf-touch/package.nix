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
  version = "0-unstable-2025-02-11";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-touch";
    rev = "093d8943df03cc8a2667990a065513c1bf2b57e0";
    hash = "sha256-gEBwXTd42UePgxI8rYmdLBF6cVagmtVANYzeleq0c7s=";
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
