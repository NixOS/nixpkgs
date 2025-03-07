{ lib, rustPlatform, fetchFromGitHub, pkg-config
, cairo, gdk-pixbuf, glib, libinput, libxml2, pango, udev
}:

rustPlatform.buildRustPackage {
  pname = "tiny-dfr";
  version = "0.3.0-unstable-2024-07-10";

  src = fetchFromGitHub {
    owner = "WhatAmISupposedToPutHere";
    repo = "tiny-dfr";
    rev = "a066ded870d8184db81f16b4b55d0954b2ab4c88";
    hash = "sha256-++TezIILx5FXJzIxVfxwNTjZiGGjcZyih2KBKwD6/tU=";
  };

  cargoHash = "sha256-q0yx4QT6L1G+5PvstXjA4aa0kZPhQTpM8h69dd/1Mcw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo gdk-pixbuf glib libinput libxml2 pango udev ];

  postConfigure = ''
    substituteInPlace etc/systemd/system/tiny-dfr.service \
        --replace-fail /usr/bin $out/bin
    substituteInPlace src/*.rs --replace-quiet /usr/share $out/share
  '';

  postInstall = ''
    cp -R etc $out/lib
    cp -R share $out
  '';

  meta = with lib; {
    homepage = "https://github.com/WhatAmISupposedToPutHere/tiny-dfr";
    description = "Most basic dynamic function row daemon possible";
    license = [ licenses.asl20 licenses.mit ];
    mainProgram = "tiny-dfr";
    maintainers = [ maintainers.qyliss ];
    platforms = platforms.linux;
  };
}
