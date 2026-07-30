{
  lib,
  stdenv,
  fetchFromGitHub,
  wxwidgets_3_2,
  texinfo,
  tetex,
  wrapGAppsHook3,
  autoconf-archive,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ucblogo-code";
  version = "6.2.5";

  src = fetchFromGitHub {
    owner = "jrincayc";
    repo = "ucblogo-code";
    tag = "version_${finalAttrs.version}";
    hash = "sha256-QofC7G6IS5TNxwRm23uhuThLou05etGuG/S3Wm29yUI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    texinfo
    tetex
    wrapGAppsHook3
  ];

  buildInputs = [
    wxwidgets_3_2
  ];

  meta = {
    description = "Berkeley Logo interpreter";
    homepage = "https://github.com/jrincayc/ucblogo-code";
    changelog = "https://github.com/jrincayc/ucblogo-code/blob/${finalAttrs.src.rev}/changes.txt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "ucblogo-code";
    platforms = lib.platforms.all;
  };
})
