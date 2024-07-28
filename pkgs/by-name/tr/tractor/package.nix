{
  lib,
  fetchzip,
  python3Packages,
  gobject-introspection,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "tractor";
  version = "4.5.1";

  pyproject = true;

  src = fetchzip {
    url = "https://framagit.org/tractor/tractor/-/archive/${version}/tractor-${version}.zip";
    hash = "sha256-vAKtC1L8sVpMXQowa9s9NJCppVTXEQeLplVp0pZkz84=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  dependencies = [
    python3Packages.setuptools
    python3Packages.fire
    python3Packages.pygobject3
    python3Packages.pysocks
    python3Packages.stem
  ];

  meta = with lib; {
    homepage = "https://framagit.org/tractor/tractor";
    description = "setup a proxy with Onion Routing via TOR and optionally obfs4proxy";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "tractor";
    maintainers = with maintainers; [ mksafavi ];
  };
}
