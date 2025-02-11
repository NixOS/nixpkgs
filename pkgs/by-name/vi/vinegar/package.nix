{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  xorg,
  wayland,
  vulkan-headers,
  wine64Packages,
  libGL,
  libxkbcommon,
  makeBinaryWrapper,
  nix-update-script,
}:
let
  wine = (wine64Packages.staging.override { embedInstallers = true; }).overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches or [ ] ++ [
      (fetchurl {
        name = "loader-prefer-winedllpath.patch";
        url = "https://raw.githubusercontent.com/flathub/org.vinegarhq.Vinegar/3e07606350d803fa386eb4c358836a230819380d/patches/wine/loader-prefer-winedllpath.patch";
        hash = "sha256-89wnr2rIbyw490hHwckB9g1GKCXm6BERnplfwEUlNOg=";
      })
    ];
  });
in
buildGoModule rec {
  pname = "vinegar";
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "vinegarhq";
    repo = "vinegar";
    rev = "v${version}";
    hash = "sha256-qyBYPBXQgjnGA2LnghPFOd0AO6+sQcZPzPI0rlJvGHE=";
  };

  vendorHash = "sha256-SDJIoZf/Doa/NrEBRL1WXvz+fyTDGRyG0bvQ0S8A+KA=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXcursor
    xorg.libXfixes
    wayland
    vulkan-headers
    wine
    libGL
    libxkbcommon
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    wrapProgram $out/bin/vinegar \
      --prefix PATH : ${lib.makeBinPath [ wine ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source, minimal, configurable, fast bootstrapper for running Roblox on Linux";
    homepage = "https://github.com/vinegarhq/vinegar";
    changelog = "https://github.com/vinegarhq/vinegar/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    mainProgram = "vinegar";
    platforms = [ "x86_64-linux" ];
  };
}
