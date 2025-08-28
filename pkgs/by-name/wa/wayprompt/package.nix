{
  lib,
  zig_0_13,
  stdenv,
  fetchFromSourcehut,
  fcft,
  libxkbcommon,
  pixman,
  pkg-config,
  scdoc,
  wayland,
  wayland-protocols,
  wayland-scanner,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayprompt";
  version = "0.1.2";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "wayprompt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+9Zgq5/Zbb1I3CMH1pivPkddThaGDXM+vVCzWppXq+0=";
  };

  nativeBuildInputs = [
    zig_0_13.hook
    pkg-config
    wayland
    wayland-scanner
    scdoc
  ];

  buildInputs = [
    fcft
    libxkbcommon
    pixman
    wayland-protocols
  ];

  zigDeps = zig_0_13.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-52XIiS178qraIrgLGsJj6ESS9YbQYRTsk0wrLeIgUMg=";
  };

  postFixup = ''
    substituteInPlace $out/bin/wayprompt-ssh-askpass \
      --replace-fail wayprompt $out/bin/wayprompt
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://git.sr.ht/~leon_plickat/wayprompt";
    description = "Multi-purpose (password-)prompt tool for Wayland";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sg-qwt ];
    mainProgram = "pinentry-wayprompt";
    platforms = lib.platforms.linux;
  };
})
