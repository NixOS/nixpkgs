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
}:

rustPlatform.buildRustPackage rec {
  pname = "tiny-dfr";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "tiny-dfr";
    rev = "a04f1abf4179d0e3c2ddf5c9b1a442b923680ef9";
    hash = "sha256-dUqF1ct/ioR5+cA06S8BIA8yc3FksLC0vj+FQEUfpXI=";
  };

  cargoHash = "sha256-ObE4aYHfCeQdamhSZmZbgNSHawRyUl5xFWdIhor16pI=";

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
}
