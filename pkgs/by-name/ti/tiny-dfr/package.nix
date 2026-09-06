{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cairo,
  gdk-pixbuf,
  glib,
  libinput,
  librsvg,
  libxml2,
  pango,
  udev,
  udevCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tiny-dfr";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "tiny-dfr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NwZ/uhVyI3NeI5CUsM42HUu6SpG0Lh8Mj66RY+ZuqBM=";
  };

  cargoHash = "sha256-k9mXEKn+LqFJraLm2ahGGAbVUNeNPnEwt1wGEOXeSrc=";

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    libinput
    librsvg
    libxml2
    pango
    udev
  ];

  postConfigure = ''
    substituteInPlace etc/systemd/system/tiny-dfr.service \
        --replace-fail /usr/bin $out/bin
    substituteInPlace src/*.rs --replace-quiet /usr/share $out/share
  '';

  postInstall = ''
    cp -R etc $out/lib
    cp -R share $out
  '';

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/AsahiLinux/tiny-dfr";
    description = "Most basic dynamic function row daemon possible";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    mainProgram = "tiny-dfr";
    maintainers = [ lib.maintainers.qyliss ];
    platforms = lib.platforms.linux;
  };
})
