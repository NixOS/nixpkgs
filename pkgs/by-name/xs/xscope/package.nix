{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  autoreconfHook,
  xorg-autoconf,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xscope";
  version = "1.4.5";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xorg";
    repo = "app/xscope";
    tag = "xscope-${finalAttrs.version}";
    hash = "sha256-9ZmmV41PKv+WFL9I4D9NTfNVTsazCijZMMmDFSvXMlg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    xorg-autoconf
  ];

  buildInputs = [
    xorg.libXt
    xorg.xtrans
  ];

  meta = {
    description = "program to monitor X11/Client conversations";
    homepage = "https://cgit.freedesktop.org/xorg/app/xscope/";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ crertel ];
    platforms = lib.platforms.unix;
    mainProgram = "xscope";
  };
})
