{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wlr-layout-ui";
  version = "1.6.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdev31";
    repo = "wlr-layout-ui";
    rev = "refs/tags/${version}";
    hash = "sha256-aM8KV3jzim14lBVvn/AqUsfoRWrnKtRJeFSX1Thrq3M=";
  };

  postPatch = ''
    # The hyprland default.nix patches the version.h of hyprland so that the
    # version info moves to the commit key.
    substituteInPlace src/wlr_layout_ui/screens.py \
      --replace 'json.loads(subprocess.getoutput("hyprctl -j version"))["tag"]'\
                'json.loads(subprocess.getoutput("hyprctl -j version"))["commit"]'
  '';

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyglet
    tomli
    tomli-w
  ];

  postInstall = ''
    install -Dm644 files/wlr-layout-ui.desktop $out/share/applications/wlr-layout-ui.desktop
  '';

  meta = with lib; {
    description = "A simple GUI to setup the screens layout on wlroots based systems";
    homepage = "https://github.com/fdev31/wlr-layout-ui/";
    maintainers = with maintainers; [ bnlrnz ];
    license = licenses.mit;
    mainProgram = "wlrlui";
    platforms = subtractLists platforms.darwin platforms.unix;
  };
}
