{
  lib,
  stdenv,
  fetchFromGitea,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wl-vapi-gen";
  version = "1.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "kotontrion";
    repo = "wl-vapi-gen";
    tag = finalAttrs.version;
    hash = "sha256-Wi6zDrabUjIXJuxRJ9oHYfKF1ULkim/5kHGb+pl0oc4=";
  };

  postPatch = ''
    patchShebangs wl-vapi-gen.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    python3
  ];

  meta = {
    description = "Generate vala bindings for wayland protocols";
    homepage = "https://codeberg.org/kotontrion/wl-vapi-gen";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.PerchunPak ];
    platforms = lib.platforms.all;
  };
})
