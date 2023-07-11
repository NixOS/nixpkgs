{ stdenv
, lib
, fetchFromGitHub
, cpp-utilities
, qtutilities
, qttools
, qtbase
, cmake
, perl
}:

let
  fork_awesome_release = fetchFromGitHub {
    owner = "ForkAwesome";
    repo = "Fork-Awesome";
    rev = "1.2.0";
    sha256 = "sha256-zG6/0dWjU7/y/oDZuSEv+54Mchng64LVyV8bluskYzc=";
  };
in stdenv.mkDerivation rec {
  pname = "qtforkawesome";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9e2TCg3itYtHZSvzCoaiIZmgsCMIoebh6C/XWtKz/2Q=";
  };

  buildInputs = [
    qtbase
    cpp-utilities
    qtutilities
  ];
  nativeBuildInputs = [
    cmake
    qttools
    perl
    perl.pkgs.YAML
  ];
  cmakeFlags = [
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
}

