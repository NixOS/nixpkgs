{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libdrm,
  ffmpeg_6,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "wl-screenrec";
  version = "0.1.4-unstable-2024-07-28";

  src = fetchFromGitHub {
    owner = "russelltg";
    repo = pname;
    rev = "b817accf1d4f2373cb6f466f760de35e5b8626bd";
    hash = "sha256-07O2YM9dOHWzriM2+uiBWjEt2hKAuXtRtnKBuzb02Us=";
  };

  cargoHash = "sha256-AYirjrnk8SGTXk5IjzCep2AQJYPbgHAOOf47MUDYj4k=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    wayland
    libdrm
    ffmpeg_6
  ];

  doCheck = false; # tests use host compositor, etc

  meta = with lib; {
    description = "High performance wlroots screen recording, featuring hardware encoding";
    homepage = "https://github.com/russelltg/wl-screenrec";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "wl-screenrec";
    maintainers = with maintainers; [ colemickens ];
  };
}
