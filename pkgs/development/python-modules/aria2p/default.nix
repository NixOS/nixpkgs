{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pdm-pep517
, appdirs
, loguru
, requests
, setuptools
, toml
, websocket-client
, asciimatics
, pyperclip
, aria2
, fastapi
, pytest-xdist
, pytestCheckHook
, responses
, uvicorn
}:

buildPythonPackage rec {
  pname = "aria2p";
  version = "0.11.2";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pawamoy";
    repo = pname;
    rev = version;
    hash = "sha256-z74ej6J6Yh1aVsXR5fE+XhoCzCS+zfDxQL8gKFd7tBA=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    appdirs
    loguru
    requests
    setuptools # for pkg_resources
    toml
    websocket-client
  ];

  passthru.optional-dependencies = {
    tui = [ asciimatics pyperclip ];
  };

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    aria2
    fastapi
    pytest-xdist
    pytestCheckHook
    responses
    uvicorn
  ] ++ passthru.optional-dependencies.tui;

  disabledTests = [
    # require a running display server
    "test_add_downloads_torrents_and_metalinks"
    "test_add_downloads_uris"
    # require a running aria2 server
    "test_get_files_method"
    "test_pause_subcommand"
    "test_resume_method"
  ];

  pythonImportsCheck = [ "aria2p" ];

  meta = with lib; {
    homepage = "https://github.com/pawamoy/aria2p";
    changelog = "https://github.com/pawamoy/aria2p/blob/${src.rev}/CHANGELOG.md";
    description = "Command-line tool and library to interact with an aria2c daemon process with JSON-RPC";
    license = licenses.isc;
    maintainers = with maintainers; [ koral ];
  };
}
