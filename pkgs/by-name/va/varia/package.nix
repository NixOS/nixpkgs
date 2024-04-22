{ lib
, python3Packages
, fetchFromGitHub
, aria2
, meson
, ninja
, pkg-config
, gobject-introspection
, wrapGAppsHook4
, desktop-file-utils
, libadwaita
}:

python3Packages.buildPythonApplication rec {
  pname = "varia";
  version = "2024.3.20";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "giantpinkrobots";
    repo = "varia";
    rev = "v${version}";
    hash = "sha256-kvpARXunKaybw9mNCvCTjtHTGbnbVmja5npcjFY5cdM=";
  };

  postPatch = ''
    substituteInPlace src/varia-py.in \
      --replace-fail 'aria2cexec = sys.argv[1]' 'aria2cexec = "${lib.getExe aria2}"'
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    aria2p
  ];

  postInstall = ''
    rm $out/bin/varia
    mv $out/bin/varia-py.py $out/bin/varia
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "A simple download manager based on aria2 and libadwaita";
    homepage = "https://giantpinkrobots.github.io/varia";
    license = licenses.mpl20;
    mainProgram = "varia";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
