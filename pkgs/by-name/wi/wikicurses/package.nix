{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  version = "1.4";
  pname = "wikicurses";
  pyproject = true;

  build-system = with python3Packages; [ setuptools ];

  src = fetchFromGitHub {
    owner = "ids1024";
    repo = "wikicurses";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1U7RkW31IRbn0JKiJozu4q9aFhkMGGJ3ybfg0THRJDg=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  dependencies = with python3Packages; [
    urwid
    beautifulsoup4
    lxml
  ];

  postInstall = ''
    installManPage wikicurses.1 wikicurses.conf.5
  '';

  doCheck = false;

  meta = {
    description = "Simple curses interface for MediaWiki sites such as Wikipedia";
    mainProgram = "wikicurses";
    homepage = "https://github.com/ids1024/wikicurses/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pSub ];
  };

})
