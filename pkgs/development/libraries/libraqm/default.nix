{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  freetype,
  harfbuzz,
  fribidi,
}:

stdenv.mkDerivation rec {
  pname = "libraqm";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "HOST-Oman";
    repo = "libraqm";
    rev = "v${version}";
    sha256 = "sha256-H9W+7Mob3o5ctxfp5UhIxatSdXqqvkpyEibJx9TO7a8=";
  };

  buildInputs = [
    freetype
    harfbuzz
    fribidi
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  doCheck = true;

  meta = with lib; {
    description = "A library for complex text layout";
    homepage = "https://github.com/HOST-Oman/libraqm";
    license = licenses.mit;
    maintainers = with maintainers; [ sifmelcara ];
    platforms = platforms.all;
  };
}
