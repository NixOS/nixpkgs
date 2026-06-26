{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wl-vapi-gen";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kotontrion";
    repo = "wl-vapi-gen";
    tag = finalAttrs.version;
    hash = "sha256-XdgYmxW0ndH6szq7VJ+XQEnWKHCyaWoBwEQREZnTm98=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    python3
  ];

  patchPhase = ''
    patchShebangs wl-vapi-gen.py
  '';

  meta = {
    description = "Generate vala bindings for wayland protocols";
    homepage = "https://github.com/kotontrion/wl-vapi-gen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ passivelemon ];
    platforms = lib.platforms.linux;
  };
})
