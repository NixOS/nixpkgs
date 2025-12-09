{
  lib,
  fetchFromGitHub,
  setuptools,
  requests,
  ssdpy,
  appdirs,
  pygobject3,
  gobject-introspection,
  gtk3,
  wrapGAppsHook3,
  buildPythonPackage,
  buildApplication ? false,
}:

buildPythonPackage rec {
  pname = "controku";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "benthetechguy";
    repo = "controku";
    rev = version;
    hash = "sha256-sye2GtL3a77pygllZc6ylaIP7faPb+NFbyKKyqJzIXw=";
  };

  nativeBuildInputs = [
    setuptools
  ]
  ++ lib.optionals buildApplication [
    gobject-introspection
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    requests
    ssdpy
  ]
  ++ lib.optionals buildApplication [
    gtk3
    appdirs
    pygobject3
  ];

  pythonImportsCheck = [ "controku" ];

  meta = with lib; {
    changelog = "https://github.com/benthetechguy/controku/releases/tag/${version}";
    description = "Control Roku devices from the comfort of your own desktop";
    mainProgram = "controku";
    homepage = "https://github.com/benthetechguy/controku";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mjm ];
  };
}
