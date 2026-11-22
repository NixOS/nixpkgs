{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  libpng,
  libsixel,
  libsndfile,
  ncurses,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wadgadget";
  version = "0.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "fragglet";
    repo = "WadGadget";
    tag = "wadgadget-${finalAttrs.version}";
    hash = "sha256-61JzHqP0ltPry2KhgWl906y+YOYgIQDLqbcBFYbdko8=";
  };

  postPatch = ''
    patchShebangs src/help/make_help.py

    substituteInPlace src/wadgadget.c \
      --replace-fail '"WadGadget version ?\n"' '"WadGadget version ${finalAttrs.version}\n"'
  '';

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    libpng
    libsixel
    libsndfile
    ncurses
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm444 wadgadget.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "wadgadget-(.*)"
    ];
  };

  meta = {
    description = "Terminal-based WAD editor for Doom-engine games";
    homepage = "https://github.com/fragglet/WadGadget";
    changelog = "https://github.com/fragglet/WadGadget/releases/tag/wadgadget-${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.unix;
    mainProgram = "wadgadget";
  };
})
