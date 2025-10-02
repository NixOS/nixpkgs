{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
  fetchpatch2,
}:

python3Packages.buildPythonApplication rec {
  pname = "sylkserver";
  version = "6.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "sylkserver";
    tag = version;
    hash = "sha256-A15EJs35ZgXy9db3+XC0q5fTlemLJsA945nvIY50Pa4=";
  };

  patches = [
    # should be removed with next release
    (fetchpatch2 {
      url = "https://github.com/AGProjects/sylkserver/commit/c0d943b4ff4401b2892b84d66e7cd27db7e6a927.patch";
      hash = "sha256-U0a8mRbt8c4lUcN2xYDfvXTt/sWcvi7F3/Vw5sIQPrU=";
    })
  ];

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    autobahn
    cement
    dnspython
    klein
    lxml
    msrplib
    python3-eventlib
    python3-gnutls
    sipsimple
    wokkel
    xcaplib
  ];

  pythonImportsCheck = [ "sylk" ];

  # no upstream tests exist

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/sylk-server";
  versionCheckProgramArg = "--version";

  meta = {
    description = "SIP/XMPP/WebRTC Application Server";
    homepage = "https://sylkserver.com/";
    downloadPage = "https://github.com/AGProjects/sylkserver";
    changelog = "https://github.com/AGProjects/sylkserver/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.ngi ];
    mainProgram = "sylk-server";
  };
}
