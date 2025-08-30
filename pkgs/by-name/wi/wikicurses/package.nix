{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  version = "1.4";
  format = "setuptools";
  pname = "wikicurses";

  src = fetchFromGitHub {
    owner = "ids1024";
    repo = "wikicurses";
    rev = "v${version}";
    sha256 = "0f14s4qx3q5pr5vn460c34b5mbz2xs62d8ljs3kic8gmdn8x2knm";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = with python3Packages; [
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

}
