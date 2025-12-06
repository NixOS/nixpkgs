{
  lib,
  stdenv,
  fetchFromGitea,
  autoreconfHook,
  fig2dev,
  readline,
  libX11,
  bluez,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x11basic";
  version = "1.28-65";

  src = fetchFromGitea {
    domain = "codeberg.org";
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
    libX11
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
    platforms = lib.platforms.unix;
  };
})
