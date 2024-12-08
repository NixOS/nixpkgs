{ stdenv
, lib
, fetchFromGitHub
, cmake
, qttools
, perl
, cpp-utilities
, qtutilities
, qtbase
}:

let
  fork_awesome_release = fetchFromGitHub {
    owner = "ForkAwesome";
    repo = "Fork-Awesome";
    rev = "1.2.0";
    sha256 = "sha256-zG6/0dWjU7/y/oDZuSEv+54Mchng64LVyV8bluskYzc=";
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "qtforkawesome";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "qtforkawesome";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9e2TCg3itYtHZSvzCoaiIZmgsCMIoebh6C/XWtKz/2Q=";
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

  meta = with lib; {
    homepage = "https://github.com/Martchus/qtforkawesome";
    description = "Library that bundles ForkAwesome for use within Qt applications";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
})

