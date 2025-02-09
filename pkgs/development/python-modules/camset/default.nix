{
  python312Packages,
  fetchFromGitHub,
  gobject-introspection,
  v4l-utils,
  wrapGAppsHook3,
  lib
}:

python312Packages.buildPythonPackage rec {
  name = "camset";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "azeam";
    repo = "camset";
    rev = "b813ba9b1d29f2d46fad268df67bf3615a324f3e";
    hash = "sha256-vTF3MJQi9fZZDlbEj5800H22GGWOte3+KZCpSnsSTaQ=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    python312Packages.pygobject3
    python312Packages.opencv4
    v4l-utils
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "GUI for Video4Linux adjustments of webcams";
    homepage = "https://github.com/azeam/camset";
    license = licenses.asl20;
    maintainers = with maintainers; [ AaronVerDow ];
  };
}
