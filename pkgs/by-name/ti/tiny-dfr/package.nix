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
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "WhatAmISupposedToPutHere";
    repo = "tiny-dfr";
    rev = "v${version}";
    hash = "sha256-G4OeYZH3VF6fKWxHYLTmwzQmQ4JupgYNH/6aJSgINvg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/PtoAc2ZNJfW5gegcFQAAlEmjSMysZ+QebVfHtW35Nk=";

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

  meta = with lib; {
    homepage = "https://github.com/WhatAmISupposedToPutHere/tiny-dfr";
    description = "Most basic dynamic function row daemon possible";
    license = [
      licenses.asl20
      licenses.mit
    ];
    mainProgram = "tiny-dfr";
    maintainers = [ maintainers.qyliss ];
    platforms = platforms.linux;
  };
}
