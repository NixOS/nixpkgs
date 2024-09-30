{ lib, rustPlatform, fetchFromGitHub, pkg-config
, cairo, gdk-pixbuf, glib, libinput, libxml2, pango, udev
}:

rustPlatform.buildRustPackage rec {
  pname = "tiny-dfr";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "WhatAmISupposedToPutHere";
    repo = "tiny-dfr";
    rev = "v${version}";
    hash = "sha256-0nopB2gCa80hwXoEaVuGhPOncLFA/u5XydCSPiCDUlg=";
  };

  cargoHash = "sha256-w3trbTbRfHNekQ+mKHsq8O29S33QsdTdBawxDm3+Szs=";

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
