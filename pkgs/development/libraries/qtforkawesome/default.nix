{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qttools,
  perl,
  cpp-utilities,
  qtutilities,
  qtbase,
}:

let
  fork_awesome_release = fetchFromGitHub {
    owner = "ForkAwesome";
    repo = "Fork-Awesome";
    tag = "1.2.0";
    hash = "sha256-zG6/0dWjU7/y/oDZuSEv+54Mchng64LVyV8bluskYzc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qtforkawesome";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "qtforkawesome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-djYgZt1mNmV5yLfQH/DPikfOPqtF11XZCTOfNXHur28=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    perl
    perl.pkgs.YAML
  ];

  buildInputs = [
    qtbase
    cpp-utilities
    qtutilities
  ];

  cmakeFlags = [
    "-DQT_PACKAGE_PREFIX=Qt${lib.versions.major qtbase.version}"
    # Current freetype used by NixOS users doesn't support the `.woff2` font
    # format, so we use ttf. See
    # https://github.com/NixOS/nixpkgs/pull/174875#discussion_r883423881
    "-DFORK_AWESOME_FONT_FILE=${fork_awesome_release}/fonts/forkawesome-webfont.ttf"
    "-DFORK_AWESOME_ICON_DEFINITIONS=${fork_awesome_release}/src/icons/icons.yml"
  ];

  dontWrapQtApps = true;

  meta = {
    homepage = "https://github.com/Martchus/qtforkawesome";
    description = "Library that bundles ForkAwesome for use within Qt applications";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
