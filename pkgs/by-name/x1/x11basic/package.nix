{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  fig2dev,
  readline,
  libx11,
  bluez,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x11basic";
  version = "1.28-65";

  src = fetchFromCodeberg {
    owner = "kollo";
    repo = "X11Basic";
    tag = finalAttrs.version;
    hash = "sha256-07sRUFKJ4CYMtQhRu18PElvNQN2DyKkRJUt7oIhenkA=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    chmod -R u+w examples/compiler
    substituteInPlace configure.in \
      --replace-fail "main(foo)" "int main(int foo)"
  '';

  nativeBuildInputs = [
    autoreconfHook
    fig2dev
  ];

  buildInputs = [
    readline
    libx11
    SDL2
    bluez
  ];

  configureFlags = [
    "--with-bluetooth"
    "--with-usb"
    "--with-readline"
    "--with-sdl"
    "--with-x"
    "--enable-cryptography"
  ];

  preInstall = ''
    touch x11basic.{eps,svg}
    mkdir -p $out/{bin,lib}
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    cp -r ../examples $out/share/.
  '';

  meta = {
    homepage = "https://x11-basic.codeberg.page";
    description = "Basic interpreter and compiler with graphics capabilities";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ edwtjo ];
    platforms = lib.platforms.unix;
  };
})
