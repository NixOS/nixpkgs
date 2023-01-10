{ lib
, buildPythonPackage
, dbus-python
, fetchFromGitHub
, gdk-pixbuf
, gobject-introspection
, gtk3
, libnotify
, networkmanager
, pygobject3
, pytest-runner
, pynacl
, pytestCheckHook
, requests_oauthlib
, setuptools
, wrapGAppsHook
}:

buildPythonPackage rec {
  pname = "eduvpn-client";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "eduvpn";
    repo = "python-${pname}";
    rev = version;
    hash = "sha256-dCVCXCPw0PCE0d6KPmuhv/V4WVQS+ucQbWoR0Lx5TDk=";
  };

  dontWrapGApps = true;

  nativeBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    wrapGAppsHook
  ];

  patches = [
    ./0001-remove-pytest-runner.patch
  ];

  buildInputs = [
    gtk3
    libnotify
    networkmanager
  ];

  propagatedBuildInputs = [
    dbus-python
    pygobject3
    pynacl
    requests_oauthlib
    setuptools
  ];

  postPatch = ''
    substituteInPlace eduvpn/utils.py \
      --replace "/usr/local" "$out"
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}");
  '';

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://raw.githubusercontent.com/eduvpn/python-eduvpn-client/${version}/CHANGES.md";
    description = "Linux client and Python client API for eduVPN";
    homepage = "https://eduvpn.org";
    license = licenses.gpl3;
    mainProgram = "eduvpn-gui";
    maintainers = with maintainers; [ kilianar ];
    platforms = platforms.linux;
  };
}
