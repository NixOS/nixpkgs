{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, aml
, ffmpeg
, gnutls
, libjpeg_turbo
, mesa
, pixman
, zlib
}:

stdenv.mkDerivation rec {
  pname = "neatvnc";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2gPDcFcu1kGIDubguL38Z0K+k7WGFf7DX8yZteedcNg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    aml
    ffmpeg
    gnutls
    libjpeg_turbo
    mesa
    pixman
    zlib
  ];

  mesonFlags = [
    (lib.mesonBool "tests" true)
  ];

  doCheck = true;

  meta = with lib; {
    description = "VNC server library";
    longDescription = ''
      This is a liberally licensed VNC server library that's intended to be
      fast and neat. Goals:
      - Speed
      - Clean interface
      - Interoperability with the Freedesktop.org ecosystem
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/any1/neatvnc/releases/tag/v${version}";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nickcao ];
  };
}
