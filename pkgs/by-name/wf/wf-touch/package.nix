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
  version = "0-unstable-2021-03-19";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-touch";
    rev = "8974eb0f6a65464b63dd03b842795cb441fb6403";
    hash = "sha256-MjsYeKWL16vMKETtKM5xWXszlYUOEk3ghwYI85Lv4SE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkg-config
    cmake
    ninja
  ];

  propagatedBuildInputs = [ glm ];

  mesonBuildType = "release";

  postPatch = ''
    # doctest is header-only, fix the meson build to not try to link against the library
    substituteInPlace meson.build \
      --replace-fail "doctest = dependency('doctest', required: get_option('tests'))" \
      "doctest = declare_dependency(include_directories: include_directories('${doctest}/include'))"
  '';

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
