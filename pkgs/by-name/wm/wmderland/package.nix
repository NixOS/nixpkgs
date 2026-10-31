{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libnotify,
  libx11,
  xorgproto,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmderland";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "aesophor";
    repo = "wmderland";
    tag = finalAttrs.version;
    hash = "sha256-kzd5Wo+HruPC8R7UENyvjTOXBs0gmYWd5wVykr/DQHY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeBuildType = "MinSizeRel";

  patches = [ ./0001-remove-flto.patch ];

  postPatch = ''
    substituteInPlace src/util.cc \
      --replace "notify-send" "${libnotify}/bin/notify-send"
  '';

  buildInputs = [
    libx11
    xorgproto
  ];

  postInstall = ''
    install -Dm0644 -t $out/share/wmderland/contrib $src/example/config
    install -Dm0644 -t $out/share/xsessions $src/example/wmderland.desktop
  '';

  passthru = {
    tests.basic = nixosTests.wmderland;
    providedSessions = [ "wmderland" ];
  };

  meta = {
    description = "Modern and minimal X11 tiling window manager";
    homepage = "https://github.com/aesophor/wmderland";
    changelog = "https://github.com/aesophor/wmderland/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = libx11.meta.platforms;
    maintainers = with lib.maintainers; [ takagiy ];
    mainProgram = "wmderland";
  };
})
