{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libnotify,
  libX11,
  xorgproto,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "wmderland";
  version = "unstable-2020-07-17";

  src = fetchFromGitHub {
    owner = "aesophor";
    repo = "wmderland";
    rev = "a40a3505dd735b401d937203ab6d8d1978307d72";
    sha256 = "0npmlnybblp82mfpinjbz7dhwqgpdqc1s63wc1zs8mlcs19pdh98";
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
    libX11
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

  meta = with lib; {
    description = "Modern and minimal X11 tiling window manager";
    homepage = "https://github.com/aesophor/wmderland";
    license = licenses.mit;
    platforms = libX11.meta.platforms;
    maintainers = with maintainers; [ takagiy ];
    mainProgram = "wmderland";
  };
}
