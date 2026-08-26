{
  lib,
  stdenv,
  fetchFromGitHub,
  slurp,
  grim,
  zenity,
  wl-clipboard,
  imagemagick,
  makeWrapper,
  bash,
  libnotify,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wl-color-picker";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "jgmdev";
    repo = "wl-color-picker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u04eO5QfIEBNEoh9w0w2Kz+vyCLuIzCStyz+lKarF3w=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    bash
  ];

  patchPhase = ''
    patchShebangs .
    substituteInPlace Makefile \
      --replace "which" "ls" \
      --replace "grim" "${lib.getExe grim}" \
      --replace "slurp" "${lib.getExe slurp}" \
      --replace "zenity" "${lib.getExe zenity}" \
      --replace "convert" "${lib.getExe' imagemagick "convert"}" \
      --replace "wl-copy" "${lib.getExe' wl-clipboard "wl-copy"}" \
      --replace "notify-send" "${lib.getExe' libnotify "notify-send"}"
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/usr/bin/wl-color-picker \
      --prefix PATH : ${
        lib.makeBinPath [
          grim
          slurp
          imagemagick
          zenity
          wl-clipboard
          libnotify
        ]
      }
    mkdir -p $out/bin
    ln -s $out/usr/bin/wl-color-picker $out/bin/wl-color-picker
  '';

  meta = {
    description = "Wayland color picker that also works on wlroots";
    homepage = "https://github.com/jgmdev/wl-color-picker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.linux;
    mainProgram = "wl-color-picker";
  };
})
