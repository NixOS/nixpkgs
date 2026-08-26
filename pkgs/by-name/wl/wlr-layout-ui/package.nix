{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "wlr-layout-ui";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdev31";
    repo = "wlr-layout-ui";
    tag = finalAttrs.version;
    hash = "sha256-qKIf4J7l4WNGvfOqZSL4pt47/yhty7A1s3FRjB2CTPU=";
  };

  nativeBuildInputs = [
    python3.pkgs.hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyglet
    tomli
    tomli-w
    jeepney
  ];

  postInstall = ''
    install -Dm644 files/wlr-layout-ui.desktop $out/share/applications/wlr-layout-ui.desktop
  '';

  meta = {
    description = "Simple GUI to setup the screens layout on wlroots based systems";
    homepage = "https://github.com/fdev31/wlr-layout-ui/";
    maintainers = with lib.maintainers; [ bnlrnz ];
    license = lib.licenses.mit;
    mainProgram = "wlrlui";
    platforms = lib.subtractLists lib.platforms.darwin lib.platforms.unix;
  };
})
