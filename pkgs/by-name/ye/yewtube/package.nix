{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # yewtube currently does not support httpx>=0.28.0, see:
      # https://github.com/mps-youtube/yewtube/issues/1303
      httpx = super.httpx.overridePythonAttrs rec {
        version = "0.27.2";
        src = fetchPypi {
          pname = "httpx";
          inherit version;
          hash = "sha256-98K+HS88PDFg1EGAJAayBsK3b1lHsREV5t8QxsZeZsI=";
        };
      };
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "yewtube";
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = "mps-youtube";
    repo = "yewtube";
    tag = "v${version}";
    hash = "sha256-+V9t71Z8PKioM7HWlzTB6X7EokAWgqC3fQJr5tkPdq8=";
  };

  postPatch = ''
    # Don't try to detect the version at runtime with pip
    substituteInPlace mps_youtube/__init__.py \
      --replace "from pip._vendor import pkg_resources" "" \
      --replace "__version__ =" "__version__ = '${version}' #"
  '';

  propagatedBuildInputs = with python.pkgs; [
    pyperclip
    requests
    youtube-search-python
    yt-dlp
    pylast
  ];

  checkInputs = with python.pkgs; [
    pytestCheckHook
    dbus-python
    pygobject3
  ];

  preCheck = ''
    export XDG_CONFIG_HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "mps_youtube" ];

  meta = with lib; {
    description = "Terminal based YouTube player and downloader, forked from mps-youtube";
    mainProgram = "yt";
    homepage = "https://github.com/mps-youtube/yewtube";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      fgaz
      koral
    ];
  };
}
